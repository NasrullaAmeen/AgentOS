# GitHub Research — Apify open-source surface, activity, ecosystem (RQ2 + feed for RQ3/RQ7)

Date: 2026-09-08 · Channel: github-research · Confidence: A = primary (GitHub API/repo), B = reliable secondary (official README/docs), C = inferred

## Summary

Apify runs one of the most active scraping/AI-agent OSS portfolios on GitHub: **Crawlee JS (25.7k★)** and **Crawlee Python (9.5k★)** are the anchor libraries — both **Apache-2.0**, with ~133 and ~50 contributors, weekly-to-monthly releases, and 63/55 PRs merged in the last 30 days respectively. Its AI-agent layer is expanding fast: **apify-mcp-server (6.3k★, MIT)** ships weekly+, and in 2026 the org pushed a broad coding-agent plugin offensive (Claude Code, Codex, Cursor, Copilot, opencode, Kimi, etc.) plus a Rust core rewrite of Crawlee (v4 RC, impit + fs-storage-native). **Legally, the entire crawl runtime and SDK stack is forkable/self-hostable today (Apache-2.0/MIT)**; the cloud-only moat (actor marketplace with 8k+ actors, hosted storage/queues, proxy network, billing/Compute Units) lives in proprietary services, not in the open repos. Two notable license gaps: `agent-skills` (2.4k★) and `actor-templates` have **no LICENSE file** — legally ambiguous, do not fork blindly. Adoption signals: crawlee 621k npm downloads/month, 2,280 dependent repos on GitHub; apify/actor-node Docker image 3.08M pulls.

---

## Q&A

### Q1. Repo inventory under `apify/*` — what exists, by size/license/language

Org: `apify` (259 public repos, created 2016-12-15). Inventory of repos ≥ ~35 stars (GitHub API, 2026-09-08; A):

| Repo | Stars | License | Language | Last release / push | Notes |
|---|---|---|---|---|---|
| `apify/crawlee` (ex `apify-js`) | 25,686 | Apache-2.0 | TypeScript | v3.18.1 (2026-08-12); v4.0.0-rc.0 (2026-08-13) | Anchor JS SDK+crawler. 1655 forks, 145 open issues, ~133 contributors |
| `apify/crawlee-python` | 9,489 | Apache-2.0 | Python | v1.10.0 (2026-08-31) | 803 forks, 86 open issues, ~50 contributors |
| `apify/apify-mcp-server` | 6,281 | MIT | TypeScript | v0.15.4 (2026-09-02) | Official MCP server; hosted at mcp.apify.com |
| `apify/fingerprint-suite` | 2,595 | Apache-2.0 | TS | pushed 2026-09-03 | Browser fingerprint generator/injector, stealth |
| `apify/agent-skills` | 2,369 | **none (no LICENSE)** | Python | pushed 2026-08-27 | "Collection of Apify agent skills" |
| `apify/got-scraping` | 770 | Apache-2.0 (package.json; no LICENSE file) | TS | pushed 2026-08-26 | Scraping HTTP client (got-based) |
| `apify/mcpc` | 769 | Apache-2.0 | TypeScript | pushed 2026-09-07 | Universal MCP CLI client (Apify-built) |
| `apify/impit` | 587 | Apache-2.0 | Rust | pushed 2026-09-08 | Rust TLS-fingerprint browser-impersonation HTTP client — Crawlee v4 default |
| `apify/camoufox-js` | 267 | MPL-2.0 | TypeScript | pushed 2026-08-20 | Camoufox (anti-detect Firefox) JS bindings |
| `apify/awesome-skills` | 249 | Apache-2.0 | Python | pushed 2026-08-13 | Agent-skills index |
| `apify/apify-sdk-js` | 184 | Apache-2.0 | MDX/TS | v3.7.2 (2026-05-11) | Platform SDK JS (docs.apify.com/sdk/js) |
| `apify/apify-sdk-python` | 175 | Apache-2.0 | Python | v4.0.2 (2026-09-03) | Platform SDK Python |
| `apify/apify-client-python` | 96 | Apache-2.0 | Python | v3.2.0 (2026-09-03) | REST API client |
| `apify/apify-client-js` | 88 | Apache-2.0 | TypeScript | v2.25.0 (2026-08-11) | REST API client |
| `apify/mcp-client-capabilities` | 80 | Apache-2.0 | TS | pushed 2026-09-02 | MCP client capability index |
| `apify/actor-rag-web-browser` | 77 | Apache-2.0 | TS | pushed 2026-09-07 | Flagship RAG-web-search Actor |
| `apify/actor-templates` | 60 | ISC declared in package.json, **no LICENSE file** | mixed | no releases | Official Actor/scraper templates (JS/Python/TS) |
| `apify/super-scraper` | 43 | **none (no LICENSE)** | TS | pushed 2026-08-19 | "Drop-in replacement for ScrapingBee/ScrapingAnt/ScraperAPI — open-source" |

Smaller but active: `apify-client-{go,rust,java,dotnet,php}` (1–3★ each, all Apache-2.0, all pushed 2026-09-07 — 7-language client coverage), `n8n-nodes-apify` (MIT), `langchain-apify` (Apache-2.0), `actor-mcp-servers` (MIT, 21★), `push-actor-action` (Apache-2.0, 16★), `homebrew-tap` (14★), `crawlee-storage` (Rust, Apache-2.0, 3★).

Sources: GitHub API list of `orgs/apify/repos` pages 1–3 (A); per-repo `repos/apify/<name>` detail (A).

### Q2. Matching repos from the plan — verification

- `crawlee` ✅ — exists, 25.7k★, Apache-2.0 (see Q1). **Note:** `apify-js` returns the `crawlee` repo via API redirect — `apify-js` was renamed/absorbed into Crawlee (same created_at 2016-08-26, same fork count 1655); "apify-js" as a product name is legacy (A).
- `crawlee-python` ✅ — 9.5k★, Apache-2.0, created 2024-01-10 (A).
- `apify-sdk-python` ✅ — 175★, Apache-2.0, v4.0.2 (2026-09-03) (A).
- `apify-js` → see crawlee (A).
- `apify-client-js` ✅ 88★, `apify-client-python` ✅ 96★ — both Apache-2.0 (A).
- `actor-templates` ✅ — 60★, no releases, no LICENSE file; package.json declares `"license": "ISC"` (A). Contains ~40+ zipped templates incl. `python-crewai`, `python-llamaindex-agent`, `python-smolagents`, `python-pydanticai`, `python-langgraph`, `js-langgraph-agent`, `ts-beeai-agent`, `ts-mastraai`, `python-mcp-proxy` (A — git tree listing).
- `first-solvers` ❌ — 404, does not exist under `apify/*` (possibly private or a Store Actor, not a repo) (A).
- `watcher` ❌ — 404 under `apify/*`; closest public repo is `mongo-watcher-actor` (0★). Possibly private or the plan's name is wrong (A).

### Q3. License analysis — what is open vs source-available/proprietary

**Fully open and permissive (forkable/self-hostable):**
- Crawlee JS + Python: Apache-2.0 — confirmed via GitHub API SPDX + `LICENSE.md` in repo root (A).
- apify-sdk-js / apify-sdk-python / apify-client-{js,python,go,rust,java,dotnet,php}: all Apache-2.0 (A).
- apify-mcp-server: **MIT** (most permissive of the portfolio) — `LICENSE.md` head confirms "MIT License Copyright (c) 2025 Apify" (A).
- impit, fingerprint-suite, mcpc, crawlee-storage, n8n-nodes-apify (MIT), langchain-apify, apify-haystack, actor-mcp-servers (MIT), push-actor-action: permissive (A).
- got-scraping: `package.json` declares Apache-2.0, but **no LICENSE file in repo** — contractor-ambiguous but declared permissive (B).

**Legally ambiguous (no LICENSE file — default copyright applies):**
- `agent-skills` (2,369★): git tree scan for LICENSE → none in entire tree (A). Unlicensed.
- `actor-templates` (60★): no LICENSE file; `package.json` declares ISC (A). Ambiguous.
- `super-scraper` (43★): no LICENSE file — despite README calling it "open-source" (A).
- `actor-code-runtime`, `actions`, `workflows`, `apify-agent`, `apify-actor-utils`: no license (A).

**Proprietary (no public repo on GitHub):** the Apify Cloud itself — actor runtime orchestration/billing, request-queue/KV/dataset hosted backends, proxy network (residential/datacenter), Actor Store, Compute Unit metering. These are documented at docs.apify.com but not open-sourced (C — absence of repos + docs-only references in SDK code is the evidence).

### Q4. Activity — commits, issues, PRs, release cadence (2025–2026)

- **Crawlee JS releases (A):** v3.13.10 (2025-07-09) → v3.18.1 (2026-08-12) = ~12 releases in 14 months, roughly monthly; **v4.0.0-rc.0 released 2026-08-13 — major rewrite in progress** (native ESM, Node 22+, zod validation, new `ServiceLocator`, `ConcurrencySystem`, Rust-based `impit` default HTTP client, Rust `@crawlee/fs-storage-native`) per official upgrading guide at crawlee.dev/docs/next/upgrading/upgrading-to-v4 (A).
- **Crawlee Python (A):** v1.8.1 (2026-07-08) → v1.10.0 (2026-08-31) = 8 releases in 8 weeks, ≈ weekly cadence.
- **apify-mcp-server (A):** v0.13.0 (2026-07-27) → v0.15.4 (2026-09-02) = 10 releases in 5 weeks, ≈ weekly+.
- **PR merge rate, last 30 days (GitHub search API, A):** crawlee 63 merged, crawlee-python 55, apify-mcp-server 45, apify-sdk-python 33.
- **Open issues (A):** crawlee 145 (100 issues + 45 PRs), crawlee-python 100 (86 + 14), apify-mcp-server 150 (all-issues+PRs).
- **Contributors (A, per_page pagination):** crawlee ~133 (top: mnmkng 1,149; B4nan 718; jancurn 711; mtrunkat 444 — core team + long-time community), crawlee-python ~50, apify-sdk-python ~32, apify-mcp-server ~45.

### Q5. Ecosystem — dependents, integrations, MCP

- **GitHub dependents (A):** crawlee → 2,280 dependent repos + 168 packages; crawlee-python → 192 dependent repos + 14 packages (incl. Upsonic 7.9k★, OpenCompany 873★, betagouv/gitscan).
- **npm downloads (A, last 30d):** `crawlee` 621,001; `@apify/actors-mcp-server` 122,148.
- **PyPI (A):** `crawlee` 175 releases, latest 1.10.0, author "Apify Technologies s.r.o."; `apify-client` 3.2.0. (Monthly download counts unavailable — pypistats.org rate-limited 429 at time of research.)
- **Official integration repos (A):** `langchain-apify`, `apify-haystack` (Apache-2.0), `n8n-nodes-apify` (MIT, maintained), plus integration-maintenance forks the org mirrors: `langchain`, `langchainjs`, `llama_index`, `Flowise`, `airbyte`, `activepieces`, `pipedream`, `windmill` (all 0–4★, low activity — monitoring forks).
- **Template-level AI support (A):** `actor-templates` ships official templates for CrewAI, LlamaIndex, LangChain, LangGraph, smolagents, PydanticAI, BeeAI, MastraAI, MCP-empty, MCP-proxy (JS/Python/TS).
- **MCP ecosystem (A):** apify-mcp-server (6.3k★, MIT) + hosted endpoint mcp.apify.com with OAuth + **agentic payments** (AGI tokens, x402, Skyfire — per README, B), `mcpc` (Apify's MCP CLI client, 769★, Apache-2.0), `mcp-client-capabilities` index, `mcp-stress-tester`. README claims compatibility with Claude Code, Claude.ai, Cursor, VS Code (B).
- **2026 AI-agent plugin offensive (A):** org repos created/active 2025–2026: `apify-claude-code-plugin`, `apify-codex-plugin`, `apify-cursor-plugin`, `apify-github-copilot-plugin`, `apify-opencode-plugin`, `apify-kimi-code-plugin`, `apify-qoder-plugin`, `apify-grok-build-plugin`, `apify-hermes-agent-plugin`, `apify-openclaw-plugin`, `apify-pi-plugin`, `xai-plugin-marketplace`, `apify-copilot-agent`, `strands-*` (apify/strands-apify, strands-harness-sdk, strands-docs), `agent-skills`, `build-deploy-monetize-ai-agents`. This is a deliberate distribution strategy into every coding-agent harness (A for existence, C for strategy intent).
- **Actor Store scale signal (B):** apify-mcp-server README embeds a video titled "Integrate 8,000+ Apify Actors and Agents with Claude" → ≥8k marketplace actors. (A-number confirmation is web-research's job.)

### Q6. Security posture

- **GitHub Security Advisories (A):** crawlee: 0 advisories; crawlee-python: 1 advisory — **CVE-2026-46497** (low, "SSRF via sitemap-derived URLs", published 2026-05-15); apify-mcp-server: 2 advisories — **CVE-2026-50143** (high, "Actor MCP path authority injection leaks Apify token", published 2026-05-28) and CVE-2026-46341 (medium, "Domain Allowlist Bypass in fetch-apify-docs via String Prefix Matching", 2026-05-13).
- Reading: the org runs a real GHSA disclosure process (A); the MCP server had a high-severity token-leak advisory in May 2026 — the AI-agent integration layer is the attack surface to watch (A+B).
- Docker base `apify/actor-node` (apify/actor-node): 3,079,620 pulls, active (updated 2026-09-07) — the standard Actor runtime image (A).

### Q7. Top-line: what a competitor could legally fork/self-host today

- **Full crawl-engine stack, Apache-2.0:** Crawlee JS + Python — crawler scheduling, request queues, KV/dataset abstractions, memory/fs storage backends, session/proxy-rotation logic, retries, fingerprints (fingerprint-suite Apache-2.0), stealth HTTP client (impit Apache-2.0), MCP integration layer (MIT — the most permissive piece).
- **7-language API client SDKs, Apache-2.0** — useful if building to Apify's public API (interop, not competition).
- **Not cleanly forkable:** actor-templates (no LICENSE), agent-skills (no LICENSE), super-scraper (no LICENSE despite "open-source" claim).
- **Not open at all:** hosted runtime (container orchestration + billing + Compute Unit metering), hosted storages (request queue/KV/dataset as a service), proxy network (residential/datacenter groups), Actor Store marketplace, MCP hosted endpoint. Anyone competing must build these; the open half (Crawlee) is Apache-2.0 so Apify cannot prevent forks, but the *products* (Actors, hosting) are closed.
- Legal-equivalence note: licensing both ways — a competitor could legally fork Crawlee (with attribution) but would compete against an org that owns the trademark + the network effects (marketplace, proxies, brand) (A licenses; C on the implications).

---

## Signals

**Activity (very high):**
- 63 PRs merged/30d (crawlee), 55 (crawlee-python), 45 (apify-mcp-server): a well-resourced, CI-heavy core team. Refs: GitHub search API (A).
- Crawlee v4 major rewrite in RC as of 2026-08: Rust impit client, ESM-only, Node 22+ — engineering velocity toward stealth/performance. Ref: crawlee.dev v4 upgrade guide (A), release v4.0.0-rc.0 (A).

**Maintenance (healthy, disclosed):**
- Weekly+ release cadence on all flagship repos (A). 0 advisories on JS Crawlee; low SSRF on Python (fixed/disclosed 2026-05); high token-leak on MCP server (disclosed 2026-05) — transparent GHSA process (A).

**Adoption (strong):**
- 25.7k★ / 9.5k★ flagship; 621k npm dl/mo crawlee; 122k npm dl/mo MCP server; 2,280+192 GitHub dependent repos; 3.08M Docker pulls for actor-node; 175 PyPI releases (A).

**AI-agent pivot (aggressive):**
- 15+ coding-agent plugin repos created 2025–2026 (Claude Code, Codex, Cursor, Copilot, Kimi, Qoder, Grok, opencode, Hermes, OpenClaw, xAI marketplace), MCP server + agentic payments (x402/AGI/Skyfire), templates for every major agent framework (CrewAI/LlamaIndex/smolagents/PydanticAI/BeeAI/Mastra), plus `strands` internal AI-agent platform repos (A for existence).

**Security posture:** disclosure-driven; one high advisory on the MCP token path in 2026 (A).

**Open-vs-closed boundary (the key competitor fact):** runtime+SDKs+MCP = open (Apache-2.0/MIT); marketplace, hosted storages/queues, proxy network, billing = closed (A for license facts).

## Unresolved

1. **`agent-skills`, `actor-templates`, `super-scraper` licensing:** no LICENSE files found; package.json declarations (ISC/Apache-2.0 claims for got-scraping) may govern or not — needs legal interpretation, out of GitHub-scope. Flagged for reverse-engineering/analysis.
2. **`first-solvers` and `watcher` repos:** 404 under `apify/*`. Possibly private or Store-Actor names, or the plan's names are stale. Unverified.
3. **Actor Store exact count (8,000+ claim):** only B-level evidence (MCP README video title). Web-research should confirm from apify.com/store.
4. **Monthly PyPI download counts** for crawlee/apify-client: pypistats.org returned 429; not verified.
5. **Headcount/funding** — not resolvable from GitHub org data alone (org member counts are private); belongs to web-research.
6. **Whether Crawlee v4 (RC) ships stable before 2026-12** — RC released 2026-08-13; status A+ observable later, unverifiable at time of writing.
7. **"strands" product scope** — repos exist (strands-apify, strands-harness-sdk, strands-docs) but public docs are thin; what it is commercially is unverifiable from GitHub.