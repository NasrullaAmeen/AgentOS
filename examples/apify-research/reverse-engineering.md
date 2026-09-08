# Reverse Engineering — Apify as a system: what a competitor would actually have to build

Slug: `apify` · Date: 2026-09-08 · Channel: reverse-engineering (batch 2, reads github.md/web.md)
Confidence: A = primary (docs.apify.com / repo source), B = reliable secondary, C = inferred/estimated

## Summary

Apify is a **Docker-container execution platform with a two-sided marketplace on top**: Actors are ordinary Docker images (any language, JS/Python blessed) wrapped in a metadata contract (`actor.json` + JSON-Schema input/output + env-var runtime contract), executed on Apify's closed worker fleet, metered as **Compute Units = memory GB × hours**, and charged against a prepaid-credit balance by a charging system that is *woven into the open SDKs* (pushData interception, pay-per-event). Everything a developer touches in the open — Crawlee (JS+Python, Apache-2.0), SDKs, clients (7 languages), MCP server (MIT), proxy gateway (`proxy-chain`, Apache-2.0) — is forkable today; **everything that makes money is closed**: worker orchestration/lifecycle, hosted storage backends (request-queue locking is a genuinely non-trivial distributed primitive), the residential/datacenter proxy network, the Store marketplace (search, quality score, monetization, payouts), and the 2026 x402/agentic-payments layer (AGI token minting sits behind `agi.apify.com`, closed). Build-vs-rent: a competitor can rent the entire open stack in weeks, but the moat is network effects (8k–52k actors), proxy supply, scale reliability (99.95%, SOC 2), and the billing/payouts back-office — not the code.

---

## Architecture map

```
                        ┌─────────────────── APIFY CLOUD (closed) ───────────────────┐
  User / Agent          │                                                             │
  ────────────────      │  ┌──────────────┐   ┌──────────────────────────────────┐    │
  Apify Console (UI)    │  │ Public REST  │   │ Worker fleet:                    │    │
  apify CLI             │  │ API v2       │──▶│  Docker runtime per Actor run    │    │
  API clients (7 langs) │  │ api.apify.com│   │  · memory/CPU/disk allocation    │    │
  MCP clients (Claude,  │  └──────┬───────┘   │  · lifecycle READY→RUNNING→term   │    │
  Cursor, Codex, ...)   │         │           │  · run migration/resurrection     │    │
  ────────────────      │         ▼           │  · schedule/cron + webhooks       │    │
  OPEN (forkable)       │  ┌──────────────┐   │  · CU metering + charge API       │    │
  · Crawlee JS/Py 3.x   │  │ Actor Store  │   └───────────────┬───────────────────┘    │
  · Crawlee v4 (Rust    │  │ marketplace  │                   │ HTTP (managed via SDK) │
  ·   impit/fs-native)  │  │ (8k–52k)     │                   ▼                        │
  · Apify SDK JS/Py     │  │ quality score│   ┌──────────────────────────────────┐    │
  · apify-client-*      │  │ monetization │   │ HOSTED STORAGE (closed)          │    │
  · MCP server (MIT)    │  │ x402/AGI     │   │  · Key-value store (S3-backed)   │    │
  · proxy-chain gateway │  └──────────────┘   │  · Datasets (append-only)        │    │
  · fingerprint-suite / │                     │  · Request queues (lock/dedupe)  │    │
  ·   impit / camoufox  │                     └──────────────────────────────────┘    │
                        │   ┌───────────────────────────────────────────────┐         │
                        │   │ Proxy edge: proxy.apify.com (open proxy-chain │         │
                        │   │ gateway) → closed networks: residential pool,│         │
                        │   │ DC groups (SHADER-style), SERP, Unblocker    │         │
                        │   └───────────────────────────────────────────────┘         │
                        └─────────────────────────────────────────────────────────────┘
```

Data flow (one scrape): MCP client / REST / Console → `POST /v2/actors/{owner~name}/run-sync-get-dataset-items` (or async run) → platform allocates Docker container from selected build tag, injects env contract (`ACTOR_*`/`APIFY_*`), attaches default storages (`ACTOR_STORAGES_JSON`) → Actor boots, `Actor.init()` switches SDK storage client to cloud API (see entry point 2 below) → crawler enqueues URLs to request queue (dedupe by `uniqueKey`), pushes results to dataset, writes state to KV → run exits, platform meters CUs + storage ops + proxy GB + transfer vs prepaid credit → user polls `GET /v2/datasets/{id}/items` or MCP `get-actor-output`.

---

## Entry points and key flows (with receipts)

### 1. The Actor runtime contract (what "an Actor" is)

- **Definition:** "programs packaged as Docker images, which accept a well-defined JSON input, perform an action, and optionally produce an output"; elements = `actor.json` + Dockerfile + README + input/output JSON-Schema. Source: docs.apify.com/actors/development/actor-definition (A).
- **Build→run:** builds are Docker images made from source, frozen into numbered+tagged builds (`latest`, `beta`); a run is a container from a build with dedicated resources. Runs may be **resurrected** (same storages, container restarted) or gracefully aborted (30 s window, `aborting` event). Source: docs.apify.com/actors/running/runs-and-builds (A).
- **Resource model:** memory must be a power of 2, 128 MB–32 GB; CPU = memory/4096 MB cores (e.g. 1024 MB = ¼ core, 8192 MB = 2 cores); disk = 2× memory; CPU boost at startup. Source: docs.apify.com/actors/running/usage-and-resources (A).
- **CU metering:** 1 CU = 1 GB RAM × 1 hour, second-granularity; platform usage = compute + data transfer + proxy + storage operations. Source: docs.apify.com/actors/running/usage-and-resources (A). Rates per plan $0.20→$0.13/CU: web.md:13 (A).
- **Env contract (the platform/container "API"):** documented `ACTOR_*` vars (IDs, default storage IDs via `ACTOR_STORAGES_JSON`, `ACTOR_MEMORY_MBYTES`, `ACTOR_MAX_TOTAL_CHARGE_USD`, `ACTOR_WEB_SERVER_URL`/`PORT`, `ACTOR_EVENTS_WEBSOCKET_URL`) + `APIFY_*` vars (`APIFY_TOKEN`, `APIFY_IS_AT_HOME=1`, `APIFY_PROXY_PASSWORD/PORT`, `APIFY_META_ORIGIN`). Source: docs.apify.com/actors/development/programming-interface/environment-variables (A).
- **SDK bootstrap switch:** `Actor.init()` checks `isAtHome()`; on-platform it sets `availableMemoryRatio=1`, `disableBrowserSandbox`, and `config.useStorageClient(this.apifyClient)` — i.e. the cloud REST client becomes the storage backend; off-platform it keeps Crawlee local/memory storage. Source: apify-sdk-js/src/actor.ts:536-567 (raw.githubusercontent.com/apify/apify-sdk-js/master/src/actor.ts) (A).
- The `apify` npm package (v3.7.2) is the Actor SDK shell over `@crawlee/core` + `apify-client`; the `crawlee` npm package (v3.18.1) is the crawler engine. Sources: registry.npmjs.org/apify/latest, registry.npmjs.org/crawlee/latest (A).

### 2. Storage abstractions (re-implementable; backend closed)

- **Three per-run defaults** wired via env: default KV store (input lives at key `INPUT`), default dataset, default request queue. Source: docs.apify.com/actors/running/runs-and-builds + environment-variables (A).
- **KV store:** records with MIME type, `getValue/setValue`, JSON auto-parse; **backed by AWS S3** (explicit: "Key-value storage uses the AWS S3 service… strong read-after-write") — a competitor can literally use S3. Keys ≤256 chars. Source: docs.apify.com/storage/key-value-store (A).
- **Dataset:** append-only (`pushData`), items ≤9 MB JSON, exports json/jsonl/csv/html/xlsx/xml/rss, `#`-prefixed hidden fields + `clean=1`, 400 req/s push limit. Source: docs.apify.com/storage/dataset (A).
- **Request queue — the one non-trivial backend primitive:** dedupe by `uniqueKey`, batch add/delete, **distributed locking** via `listAndLockHead(limit, lockSecs)` + `prolongRequestLock`/`deleteRequestLock` keyed by `clientKey` (multi-run safe crawling: a request locked by one run is invisible to others until lock expiry), `hadMultipleClients` signal; named queues retained indefinitely, unnamed 7 days; rate limits 400 r/s CRUD, 40 r/s batch/lock, 60 r/s others. Source: docs.apify.com/storage/request-queue (A). Offline analogue is Crawlee memory-storage/fs-storage (packages/core/src/memory-storage/*, packages/fs-storage/src/file-system-storage.ts in apify/crawlee tree) (A); Crawlee v4 adds Rust `crawlee-storage` (Apache-2.0) (B).
- Local layout mirrors cloud: `{APIFY_LOCAL_STORAGE_DIR}/{datasets,key_value_stores,request_queues}/{id}/...` (A, docs above).

### 3. Charging / pay-per-event (the monetization core — closed backend, but SDK side is open)

- **PPE model:** Actor owners define named events with prices; synthetic events `apify-actor-start` ($0.00005, covers first 5 s compute; charged once per GB of RAM) and `apify-default-dataset-item` (auto-charge per row pushed to default dataset). Profit = `0.8 × revenue − platform costs`; user-set spend cap enforced platform-side via `ACTOR_MAX_TOTAL_CHARGE_USD`. Source: docs.apify.com/actors/publishing/monetize/pay-per-event (A).
- **SDK mechanics (open, observable):** `Actor.charge({eventName, count})` → `ChargeResult { eventChargeLimitReached, chargedCount, chargeableWithinLimit }` (apify-sdk-js/src/charging.ts); **`DatasetClient.pushItems` is subclassed** (PatchedDatasetClient) so every `pushData()` on the default dataset transparently charges the `apify-default-dataset-item` event, batching-aware via `pushDataChargingContext` AsyncLocalStorage (apify-sdk-js/src/patched_apify_client.ts:40-100). The charge API endpoint itself (`POST /v2/actor-runs/{id}/charge` per docs) is closed. (A)
- **CLI surface:** `apify actor charge <event-name> [count]` (docs.apify.com/cli reference via pay-per-event docs) (A).

### 4. Proxy system (open gateway, closed network)

- **Access model:** single HTTP gateway — external `proxy.apify.com:8000` or, from inside an Actor, env `APIFY_PROXY_HOSTNAME/PORT/PASSWORD` (bypasses public internet, no external data-transfer charge). Credentials are per-account password; **username string is the routing config**: `groups-<GROUP>,session-<id>,country-<CC>` (or `auto`). Source: docs.apify.com/proxy (A).
- **Groups:** `RESIDENTIAL`, `GOOGLE_SERP`, `UNBLOCKER`, plus datacenter shared groups (docs name provider-style groups, e.g. `SHADER`; user examples show `BUYPROXIES94952` — i.e. Apify aggregates third-party DC suppliers into named pools) and dedicated/static groups for enterprise. Source: docs.apify.com/proxy + docs.apify.com/proxy/datacenter-proxy (A).
- **Datacenter:** shared pools; per-hostname IP rotation ("uses the one used longest ago for the specific hostname"), health checks, banned-IP detection per target site, session persistence 26 h. Source: docs.apify.com/proxy/datacenter-proxy (A).
- **Residential:** per-GB priced; sessions ≈30 min; country + US-state targeting. Source: docs.apify.com/proxy/residential-proxy (A).
- **Gateway is open source:** "Apify Proxy is based on the [proxy-chain](https://github.com/apify/proxy-chain) open-source npm package" — Apache-2.0, 1,021★, with custom 590–599 upstream-error codes. Source: docs.apify.com/proxy (590-599 section) + GitHub API (A).
- **Pricing vs infra (C):** residential $8/GB→$7 by tier, DC $1/IP→$0.60, SERP $2.5–1.7/1k, Unblocker $1.5–1.0/1k (web.md:17). Real supply cost is undisclosed (C); DC at ~$0.05–0.15/IP bulk and $0.6–1/IP retail implies thin margin on DC, residential is the margin/scale play (C).

### 5. Scheduler / watcher / webhooks

- Cron scheduler is a **platform feature, closed**: 6-field cron (seconds field), timezone/DST aware, min interval 10 s, ≤10 actors + 10 tasks per schedule, `@monthly`-style shortcuts. Source: docs.apify.com/actors/running/schedules (A).
- No public `apify/watcher` repo exists (github.md:51 — 404; closest `mongo-watcher-actor` 0★). Run origins incl. `SCHEDULER`, `WEBHOOK`, `ACTOR`, `MCP` (docs runs-and-builds) — the "watcher" in the plan is the closed scheduler/worker allocator. (A for absence, C for what the private impl looks like.)

### 6. MCP server + agentic payments (the AI-agent pivot — mostly open, edges closed)

- **Server:** `apify-mcp-server` (MIT, 6.3k★, npm `@apify/actors-mcp-server` 122k dl/mo — github.md:21,82). Hosted `mcp.apify.com` = Streamable HTTP + OAuth (bearer token fallback), output-schema inference for Actor tools (hosted-only); local stdio via npx. 30 req/s per user; telemetry on by default. Tools: `search-actors`, `fetch-actor-details`, `call-actor`, docs tools, run-status tools, storage read tools, task CRUD; **full-permission and rental Actors excluded**; anonymous mode for discovery-only tools. Source: docs.apify.com/integrations/mcp (A).
- **Shared ranking backend:** MCP tool ranking and Apify AI chat use the same Actor search/execution backend, quality-score-like parameters. Source: docs.apify.com/integrations/mcp (A). Closed backend.
- **x402 payments:** two paths — (a) **AGI prepaid token**: agent pays `agi.apify.com/protocols/x402/prepaid-tokens?amount=1` with USDC on Base via Coinbase Agentic Wallet (`awal`), receives a bearer token that is a spending cap, 14-day expiry, $1 min, balance-checkable; (b) **Skyfire** managed tokens; (c) **direct x402 per-request** (PPE actors only) via `mcpc` — MCP server forwards signatures in `PAYMENT-SIGNATURE` header and returns structured 402 `payment-required` responses. Source: docs.apify.com/integrations/x402 (A) + apify-mcp-server/src/payments/x402.ts (X402_META_KEY, PAYMENT_SIGNATURE_HEADER, X402_PREFERRED_SCHEMES) and src/payments/{helpers,resolve,skyfire}.ts (A).
- **Eligibility wall:** x402 works only for PPE Actors with limited permissions, no usage pass-through, KYC'd developers — i.e. Apify gates autonomous-agent payments to its most curated inventory. Source: docs.apify.com/integrations/x402 (A).

### 7. CLI / developer loop

- `apify login` → `apify create` (templates from actor-templates) → local run against `APIFY_LOCAL_STORAGE_DIR` → `apify push` (platform Docker build) → `apify run`, `apify actor charge`, `apify mcp install {claude-code,cursor,vscode,codex,kiro,antigravity}`. Source: docs.apify.com/cli + docs.apify.com/integrations/mcp (A).

---

## External surface (behavioral, no secrets)

- **API:** REST v2 at api.apify.com — `/v2/actors/{owner~name}/run-sync-get-dataset-items`, `/v2/actor-runs/{id}` (+ `/abort`, `/resurrect`), `/v2/datasets/{id}/items`, `/v2/key-value-stores/{id}/records/{key}`, `/v2/request-queues/{id}/...`, `/v2/store?search=`, `/v2/schedules`, charge endpoint. Auth = `Authorization: Bearer <token>` or `?token=`; resource IDs use `username~store-name` format. Sources: docs.apify.com proxies pages + request-queue docs + x402 page (A).
- **Authn surfaces:** account API token; MCP OAuth (hosted); `awal`-signed x402 payments (no account); prepaid AGI bearer token usable as API token. (A)
- **Rate limits:** MCP 30 r/s/user; queue CRUD 400 r/s, batch/lock 40 r/s; dataset push 400 r/s. (A)
- **Config surfaces:** `.actor/actor.json` (name, version, buildTag, env vars, min/maxMemoryMbytes); Console env vars (secret-toggleable, redacted from logs); build-time env as Docker ARG only. (A)
- **Secrets handling (behavioral):** user token injected per-run as `APIFY_TOKEN` enabling the Actor to act as the user (delegation model); proxy password per-account; input secrets encrypted with a platform-managed key (`APIFY_INPUT_SECRETS_PRIVATE_KEY_FILE`). (A) No secrets reproduced here.

## Open vs closed boundary (what a competitor builds vs rents)

**Open today (Apache-2.0 unless noted):** Crawlee JS 25.7k★ / Python 9.5k★ (github.md:19-20); Apify SDK JS (apify package, 3.7.2) & Python; API clients JS/Python/Go/Rust/Java/.NET/PHP (github.md:38); apify-mcp-server **MIT** (github.md:21); fingerprint-suite, impit (Rust TLS impersonation), got-scraping, proxy-chain gateway, mcpc; `actor-node`/`actor-python` base images (3.08M + 1.99M pulls). Ambiguous (no LICENSE file): actor-templates (ISC declared), agent-skills, super-scraper (github.md:62-66).

**Closed (must be built by a would-be competitor):** worker fleet orchestration + run migration/resurrection + cron scheduler; hosted KV (trivial — S3), dataset (trivial), **request queue (non-trivial — distributed lock/head semantics)**, storage retention/naming service; CU + data-transfer + storage-ops metering ledger; prepaid-credit billing + overage + per-plan pricing; PPE charge API + spend-limit enforcement; proxy networks (residential supply, DC suppliers, SERP, Unblocker routing); Store (search/ranking, quality score, monetization config, listings, payouts w/ KYC); MCP hosted endpoint; AGI token minting; webhooks; Apify AI chat.

## Effort estimate: self-host an Apify-like core with open components (C — assumption-labeled)

Assumptions: 1 senior backend engineer, Node/Python, no residential-proxy supply, single-region MVP, no SOC2/enterprise, no marketplace-critical mass (start with first-party scrapers only), reuse Crawlee/SDKs/MCP as-is. C confidence, order-of-magnitude only:

| Component | Person-weeks | Why |
|---|---|---|
| Docker build/run API + lifecycle (deploy build, tag, run, abort, migrate container w/ storage rebind) | 6–10 | Straightforward over K8s/Nomad; migration/resurrection subtlety |
| Request-queue service (dedupe, listAndLockHead, locks, batch, limits) | 3–5 | Distributed lock semantics + head consistency |
| Dataset + KV services (S3/Object-storage backed) | 2–3 | Near-commodity |
| CU metering + billing ledger + prepaid credit + charge API + spend caps | 5–8 | Correctness-first accounting; piped through SDK push interception |
| Proxy gateway (reuse proxy-chain) + DC pool leasing | 2–4 | Gateway is open; DC upstream supply is procurement, not code |
| Store-lite (actor metadata, input/output schema registry, search) | 3–5 | Schema-driven; ranking/quality score optional at MVP |
| MCP server integration (open source, just host/run) + x402 acceptance via AGI analogue | 2–3 | Reuse MIT code; token minting is the closed edge |
| **Total MVP (no marketplace, no residential)** | **≈25–40 pw** | ~0.5–0.8 yr for one dev, ~2–3 mo for a 3–4 person team |
| Residential proxy network (if attempted) | **indefinite + $** | Supply-side problem (peer networks, geo freshness, anti-abuse) — see hardest-things |

---

## Where the real difficulty/build-cost lies (ranked)

1. **Actor Store two-sided marketplace (network effects, not code).** 8k–52k actors, quality score, trust, `$760k/mo developer payouts` (web.md:25), top actors at 571k/371k/242k users (web.md:58). Cold-start on both sides (developers won't publish where users aren't, users won't come without inventory). Quality-score + monetization + payout back-office is real engineering but secondary to the chicken-and-egg.
2. **Residential proxy network.** Infra-heavy and supply-side: geo coverage, freshness, per-target ban detection, session affinity (~30 min residential / 26 h DC), priced at $8/GB retail vs unknown wholesale; a small team cannot buy its way to this in months. DC-only is commodity-adjacent (`proxy-chain` is open — github.md A-level, docs.apify.com/proxy A).
3. **Scale reliability + run orchestration.** 99.95% uptime, SOC 2, run migration, resurrection, webhook delivery, multi-region storage, 400 r/s per-queue backends — this is SRE burden and ops maturity, not feature code; the open SDKs hide it, which is precisely why it's not visible in github.md.
4. **Billing/metering correctness at consumption scale.** CU ledger, data transfer, storage ops, proxy GB, plan-tiered rates, prepaid credits, PPE charging with idempotency + spend caps + abort-window charging + 80/20 payouts with KYC. Small accounting errors are direct revenue/trust loss.
5. **AI-ecosystem distribution + trust brand.** The 2026 plugin offensive (15+ coding-agent plugins, MCP hosted endpoint, x402/AGI) is cheap to imitate mechanically but its value is placement + the closed hosted endpoint + enterprise references (Siemens, Microsoft, EC — web.md:44). A competitor has to earn trust from zero.

Counter-lever: the runtime/SDK/MCP layer being Apache-2.0/MIT means **the unit economics floor is public** — anyone can fork Crawlee + proxy-chain + the MCP server and run the same developer loop; what they cannot fork is the marketplace, the proxy supply, and the trust.

## Open questions

1. Real infra cost / margin of residential + DC proxy networks: only list-price inference exists (web.md:106; C).
2. Exact economics of Apify's cut on PPE: 80/20 split is published, but platform-cost attribution (per-run compute vs event revenue) is opaque — the "negative-profit isolation" rule (pay-per-event docs) hints at shared-cost partitioning we can't see. (C)
3. Actual scale of the worker fleet and storage backend (node counts, regions, queue throughput) — undocumented. (C)
4. Whether Crawlee v4 (Rust impit/fs-storage, ESM-only, Node 22+) ships stable — RC since 2026-08-13 (github.md:132); affects whether the fork-point moves.
5. "strands" internal AI-agent platform (github.md:133) — public repos exist but product scope unverifiable; may be the next shipping surface.
6. The `watcher`/scheduler private implementation (plan.md names it; no public repo) — presumably the cron + worker allocator; unobservable. (C)
7. Retention/migration behavior details of hosted request queue at multi-run scale (the `hadMultipleClients` path) beyond published API semantics. (C)