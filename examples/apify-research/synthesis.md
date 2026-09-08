# Synthesis — Apify: Reverse Engineering + "Can We Compete?"

Date: 2026-09-08 · Agent: analysis · Reads: all 5 channel files + plan.md
Confidence key: A = primary (docs/repo/fetched page), B = multi-source corroboration, C = inferred

---

## Bottom line

Apify is a profitable, bootstrapped Prague company (~$13–15M ARR, ~200 staff) that has pivoted hard into "the largest marketplace of trusted tools for AI" — 8k–52k marketplace actors, Apache-2.0 crawl engine, MIT MCP server, aggressive coding-agent plugin distribution. Its structural weakness is billing complexity (consumption-metered prepaid credits stack compute + proxy + storage + actor fees into unpredictable bills) — every channel (web, reddit, github, reverse-engineering, competitive) converges on this as the #1 complaint, and Apify's revenue model makes it structurally impossible to fix without shrinking ARPU. **We can compete, but only narrowly**: a vertical, MCP-native agent-data API with flat per-task pricing, permissive (Apache/MIT) self-hostable core, and radical pricing transparency as brand identity. The high AI-agent-DX × high billing-simplicity quadrant is real but already partially occupied (Context.dev at X4,Y5; Firecrawl at X5,Y3) — differentiation must come from vertical depth + open-core, not from "cheaper API." Estimated 9-month window before the quadrant is genuinely crowded.

---

## Findings by research question

### RQ1 — What is Apify as a business?

| Finding | Conf. | Source |
|---------|-------|--------|
| Founded 2015, Prague, YC Fellowship → bootstrapped to profitability 2019 | A | web.md Q2 (apify.com/about, Tech.eu) |
| Total funding ~$3.0–3.5M (Seed Apr 2024, €2.8M J&T Ventures + Reflex) | A/B | web.md Q2 (Tech.eu, GetLatka, Crunchbase) |
| 2023 revenue €6.7M / €1M profit; 2024 est. $13.3M–$14.7M ARR | A/B | web.md Q2 (Tech.eu primary 2023; GetLatka/Prospeo estimates 2024) |
| Headcount ~201–231 (2026) — actively hiring 12–13 roles | B | web.md Q2 (GetLatka, Caplight) |
| SOC 2 Type II, GDPR, CCPA, 99.95% uptime | B | web.md Q6 (Feb 2026 press release) |
| Enterprise customers: Siemens, Microsoft, Intercom, Groupon, European Commission | B | web.md Q2 (Tech.eu, StartupMap) |
| Positioning: "The largest marketplace of trusted tools for AI" — deliberate AI pivot | A | web.md Q3 (apify.com homepage) |

**Reading:** A capital-efficient, profitable operator — not a VC-burn competitor. Their $3.5M total funding means growth is profit-funded; a small team faces a well-capitalized but not overwhelmingly-funded opponent.

### RQ2 — Open-source surface & legal buildability

| Finding | Conf. | Source |
|---------|-------|--------|
| Crawlee JS 25.7k★ Apache-2.0 + Python 9.5k★ Apache-2.0 — full crawl engine forkable today | A | github.md Q1/Q3 |
| MCP server 6.3k★ MIT — most permissive piece | A | github.md Q3 |
| All SDKs (JS/Py/Go/Rust/Java/.NET/PHP) Apache-2.0 | A | github.md Q1 |
| proxy-chain gateway Apache-2.0 (1,021★) — open proxy routing layer | A | github.md Q1; reverse-engineering.md §4 |
| fingerprint-suite, impit (Rust TLS), got-scraping: Apache-2.0 | A | github.md Q1 |
| **NOT forkable**: agent-skills (2.4k★, NO LICENSE), actor-templates (NO LICENSE), super-scraper (NO LICENSE) | A | github.md Q3 |
| Crawlee: 621k npm dl/mo, 2,280 dependent repos, 3.08M Docker pulls | A | github.md Q5 |
| Apify SDK shell (`apify` npm) wraps `@crawlee/core` + `apify-client` — charging logic injected via `PatchedDatasetClient` subclass | A | reverse-engineering.md §1, §3 |

**Reading:** A competitor can legally fork the entire crawl runtime + MCP + proxy gateway. What they cannot fork: marketplace, hosted storage/queues (except KV=S3 trivial), proxy supply, billing, trust/brand. **Crucially**: Apify's SDK has pay-per-event charging baked into `pushData()` — forking the SDK means inheriting their monetization hooks unless surgically removed.

### RQ3 — Platform internals (what we'd have to build)

| Finding | Conf. | Source |
|---------|-------|--------|
| Actors = Docker containers; resource model: memory powers-of-2 up to 32 GB, CPU = mem/4096 cores | A | reverse-engineering.md §1 (docs.apify.com) |
| CU = 1 GB RAM × 1 hour, second-granularity metering | A | reverse-engineering.md §1 |
| Three storage layers: KV (S3-backed, trivial), dataset (append-only, commodity), request queue (distributed lock/head, non-trivial) | A | reverse-engineering.md §2 |
| Env contract: `ACTOR_*` + `APIFY_*` vars, `Actor.init()` switches SDK to cloud REST client when `isAtHome()` | A | reverse-engineering.md §1 (source-level: actor.ts:536-567) |
| **MVP self-host estimate: 25–40 person-weeks** (1 senior dev); residential proxy network: indefinite + capital | C | reverse-engineering.md §Effort estimate |
| Request queue's `listAndLockHead` + multi-client locking = the one genuinely hard distributed primitive | A | reverse-engineering.md §2 (docs.apify.com/storage/request-queue) |

**Reading:** The runtime is well-documented and the open-source Crawlee SDK already provides local-mode equivalents of all storage primitives. The hard parts to build: (1) distributed request queue at multi-run scale, (2) CU metering + billing correctness, (3) worker orchestration/resurrection, (4) residential proxy supply. **For a small-team MVP, skip (3) and (4) entirely** — run on a single-region K8s/Nomad cluster, DC-proxy-only, first-party scrapers only.

### RQ4 — What is Apify's moat?

| Finding | Conf. | Source |
|---------|-------|--------|
| Actor Store marketplace: 8k–52k actors (definition/date varies — see Conflicts below) | B | web.md Q3 (multiple third-party sources, trajectory A, count C) |
| $760k/mo developer payouts (Feb 2026) | B | web.md Q5 (Apify press release via EIN) |
| Top actors: Google Maps 571k users, Instagram 371k, TikTok 242k | B | web.md Q3 (use-apify Store API read) |
| Residential proxy network — geo coverage, freshness, anti-fingerprint; hardest infra component | C | web.md Q6, reverse-engineering.md §3 (inferred from $8/GB retail vs unknown wholesale) |
| AI-agent distribution: 15+ coding-agent plugins, MCP hosted endpoint with OAuth, x402/agentic payments | A | github.md Q5 (repo existence) |
| Enterprise trust: SOC 2 Type II + named logos (Siemens, Microsoft, EC) | A/B | web.md Q2/Q6 |
| Reliability defense: "shines with long-running jobs, persistence, and reliability at scale" (unchallenged on Reddit) | B | reddit.md §6 (r/n8n commenter) |

**Moat ranking (by defensibility):**
1. **Marketplace network effects** (hardest to replicate — chicken-and-egg)
2. **Residential proxy supply** (capital-intensive, supply-side problem)
3. **Scale reliability + SOC 2** (ops maturity, not features)
4. **AI-agent distribution trust** (cheap to imitate mechanically, expensive to earn trust)

### RQ5 — Community sentiment (Reddit, 16 threads)

| Finding | Conf. | Source |
|---------|-------|--------|
| **#1 complaint: pricing/cost unpredictability** — "costs add up fast," "$5 free plan consumed very quickly," prepaid CU model confuses users even in Apify's own subreddit | A/B | reddit.md §1, §3, §4, §8 |
| Users who churn from Apify often **build competing products** (GetXAPI, crawlyx, Figranium) — the wound is real and actionable | A/B | reddit.md §1, §2, §7 |
| **Per-run pricing punishes small runs** — $0.02/run setup event dominates small batches; insiders teach "batch or pay" | B | reddit.md §3 (r/apify insider) |
| Third-party marketplace builders feel the platform is **economically stacked against them** — first-party actors dominate top categories | B | reddit.md §4 (r/apify builder) |
| **AI-agent/MCP is the strongest positive buzz**: "Apify MCP is scary" (235 pts) — autonomous LinkedIn research via Claude, costs reported as cents | A | reddit.md §5 (r/mcp) |
| Apify considered "good middle choice" for JS-render/rotator; enterprise proxy users default to Bright Data/Oxylabs | B | reddit.md §6 |
| Price/visibility on Actor Store so poor that **third parties build Chrome extensions** to fix it | C | reddit.md §8 |
| Self-hosted alternatives (Figranium, Crawlee direct) actively pitched in r/apify itself | C | reddit.md §7 |

**Biggest unmet need:** pricing predictability + simplicity for agent/automation workflows. Users want Apify's capabilities without the billing complexity.

### RQ6 — Competitive landscape

| Finding | Conf. | Source |
|---------|-------|--------|
| Apify scores 3.94 on wedge-weighted index; Firecrawl edges it at 4.04 | B | competitive.md §3 |
| **Target quadrant (high AI-agent DX × high billing simplicity) is NOT empty**: Context.dev sits at X4,Y5; Firecrawl at X5,Y3 | A/B | competitive.md §3 tension plot |
| Context.dev: solo founder, YC S26, "#1 Product Hunt" Jul 2026, 1 credit = 1 scrape, flat billing — validates demand | B | competitive.md §3 |
| Firecrawl: 130–176k★, AGPL, clean AI-native API, BUT extract dual-billing (~$89/mo AI Extract) shows even the leader fell into the multiplier trap | B | competitive.md §3 |
| ZenRows: "no surprise invoices" positioning, bills only successful requests, but still multiplier credits + geo surcharges | B | competitive.md §3 |
| Bright Data: enterprise bar (50k+ customers, SOC2, $5+ per-product commitment floor) — not our competition | A/B | competitive.md §3 |
| Browserless: bootstrapped ~$4M ARR, SSPL-1.0 source-available — the open-core-with-teeth reference model | B | competitive.md §3 |
| **Nobody in the set offers a genuinely permissive (Apache/MIT) self-hostable agent-scrape API with a managed tier** — that lane is open | A | competitive.md §1 (cross-referenced: github.md licenses + competitive OSS scores) |

### RQ7 — Where is the white space?

| Finding | Conf. | Source |
|---------|-------|--------|
| Vertical + permissive open-core + pricing transparency as identity = 3-axis wedge, only combination unoccupied | C* | competitive.md §4 |
| "Task-based pricing + radical transparency" — identity play Apify can't copy (structurally) | C* | competitive.md §4 §2 |
| Curated/quality-gated vertical scraper with freshness SLA — nobody owns this | C* | competitive.md §4 §3 |
| Permissive (Apache/MIT) self-host + managed tier = most defensible lane, hardest to operate | B | competitive.md §4 §4 |
| **9-month clock** before the high/high quadrant is genuinely crowded (Context.dev-class entrants keep coming) | C* | competitive.md §5 |

---

## Conflicts resolved

### 1. Marketplace size: 15k → 52k

- **Claim range:** Tech.eu Apr 2024 says "1,500+" (A-era); Apify Feb 2026 press release says "15,000+" (B); third-party analysis Mar 2026 says "20,000+" (B); multiple mid-2026 comparators say "30k–52k" (B); x402 release Jun 2026 implies 22k+ eligible tools (B).
- **Resolution:** All numbers are directionally correct at different points in time with different definitions (all-listed vs premium vs x402-eligible). The trajectory from ~1.5k (2024) to tens of thousands (2026) is the defensible claim. **Exact count is C-level.** For our purposes, "large and growing" is sufficient — we are not competing on marketplace breadth.
- **Source agreement:** web.md Q3 (primary + secondary), github.md Q5 (MCP README claim), reverse-engineering.md §3 (corroborated).

### 2. Starter plan pricing: $19 vs $29

- **Claim range:** apify.com/pricing fetched today = Starter **$19/mo** (A). Multiple third parties (toolproven Aug 2026, costbench Aug 2026, automationatlas Jul 2026) report **$29** (B). scrapegraphai reports $49.
- **Resolution:** The prepaid-credit model means the "plan fee" is misleading regardless — the real cost is CU consumption + proxy + storage + actor fees stacked. web.md notes this as a plan-price churn possibility or regional variation. **Treat as C-level discrepancy** — the important fact is that the pricing model is complex, not the exact sticker price. Both $19 and $29 confirm the same strategic read: pricing is confusing and opaque.
- **Source agreement:** web.md Q1 (primary fetch + secondary corroboration), reddit.md §3 (users confirm confusion), competitive.md §3 (Apify scores 2/5 on pricing transparency).

### 3. Wedge index: Firecrawl 4.04 vs Apify 3.94

- **Claim:** competitive.md's weighted index has Firecrawl slightly ahead of Apify on wedge-weighted terms (4.04 vs 3.94).
- **Resolution:** Accepted with caveat: the index is a scan aid, not a verdict (competitive.md explicitly says so). The important takeaway is that Apify's #3 position is carried by breadth/scale while its pricing (2/5) is the exposed flank. Firecrawl's edge comes from AI-native DX + better (but still imperfect) billing. **This supports the conclusion that pricing transparency is the attack surface.**
- **Source:** competitive.md §3 (own scoring; B-level on Firecrawl/Apify scores).

### 4. Reddit channel availability

- **Conflict:** competitive.md states "Reddit sentiment: channel unavailable this run (reddit.md)" and uses no Reddit evidence. reddit.md is a successful run with 16 threads and rich data.
- **Resolution:** competitive.md was written before the Reddit agent's second (successful) run completed. The synthesis benefits from reddit.md's full data. Key Reddit evidence (pricing complaints = #1 pain, AI-agent MCP = strongest positive) is now incorporated above. This **strengthens** the competitive case: the pricing complaint is not just from third-party explainers (web.md) but from real users building alternatives (reddit.md).

### 5. Can a small team compete? (assessed across channels)

| Channel | Position | Confidence |
|---------|----------|------------|
| competitive.md | Yes, narrowly — compete with clock | C* (strategic inference) |
| reverse-engineering.md | 25–40 pw for MVP; residential proxy indefinite | C (effort estimate) |
| web.md | Market growing fast; Apify profitable but not invincible | A/B (market data) |
| reddit.md | Users actively building alternatives; pain is real | A (direct user evidence) |
| github.md | Entire crawl stack forkable Apache-2.0 | A (license verification) |

**Resolution:** All channels agree the wedge exists and is attackable. The constraint is **not feasibility but differentiation** — Context.dev already occupies "flat price + MCP." The synthesis verdict: compete, but only if the team can commit to (a) a specific vertical and (b) permissive open-core + transparency brand. Without those two, the remaining differentiation (pricing alone) is too thin.

---

## Open questions that block confident action

1. **What vertical?** The synthesis recommends vertical focus but cannot pick the domain. This requires domain knowledge + market validation that only the user/team can provide. [Blocks: everything]
2. **Context.dev's actual traction?** We know it launched Jul 2026 and hit #1 Product Hunt, but user count, revenue, and retention are unknown (B-level trust evidence, no reviews). If Context.dev is already winning the flat-billing lane, the window narrows. [Blocks: go/no-go on pricing-simple wedge]
3. **Firecrawl's extract-billing is a documented weakness** (competitive.md §3, B) — but will they fix it? If Firecrawl simplifies extraction pricing, one competitive flank closes. [Blocks: sustained differentiation on billing]
4. **Real residential proxy infrastructure cost** — only inferred from $8/GB retail (C). If residential proxy margins are thin, the proxy moat is weaker than assumed. If margins are fat, Apify has more capital to defend. [Blocks: proxy competitive strategy]
5. **"strands" internal product** — repos exist (github.md Q7) but scope is unverifiable. Could be Apify's next AI-agent platform surface. [Blocks: forward-looking competitive model]
6. **Does "we" have a domain in mind?** The plan's assumption is "AI-agent tooling with scraping capabilities" — but without a specific vertical, the recommended wedge cannot be instantiated. [Blocks: recommendation execution]

---

## Implications

### Engineering
- **Fork Crawlee + MCP server + proxy-chain as starting stack** — all Apache-2.0/MIT, legally clean. Do NOT fork agent-skills, actor-templates, or super-scraper (no LICENSE).
- **MVP scope from reverse-engineering.md**: ~25–40 pw for one senior dev: Docker build/run API + request queue + dataset/KV + CU metering + MCP hosting + DC proxy via proxy-chain. Skip residential proxies, worker fleet orchestration, marketplace, SOC 2.
- **Remove PPE charging hooks from SDK fork** — Apify's `PatchedDatasetClient` intercepts `pushData()` for billing; a fork must surgically remove this to avoid inheriting their monetization layer.

### Market / strategy
- **The wedge is real but not empty.** Context.dev proves demand (solo founder, YC S26, #1 PH). Firecrawl proves AI-native API can out-score Apify on wedge-weighted terms. **Differentiation must come from: vertical focus + permissive open-core + transparency brand** — not "cheaper API."
- **9-month window** (C* estimate) before the high/high quadrant is crowded. Context.dev-class entrants will keep coming. Speed to market matters.
- **Apify structurally cannot follow on flat pricing** — every revenue stream is metered (CU + proxy GB + storage + actor fees). A flat-pricing competitor is a structural threat Apify can only match by cannibalizing ARPU. This is the strongest durable advantage.

### Effort / risk
- **Residential proxy network is the one thing a small team cannot build.** DC-only or proxy-vendor resale is the practical floor. This means a small-team competitor cannot serve the hardest anti-bot use cases — but AI-agent data access (the wedge) typically does not require residential proxies for most vertical targets.
- **Trust gap is real.** Context.dev has 2/5 evidence and 2/5 enterprise — showing that billing simplicity alone does not close deals. A small team must invest in published benchmarks, named case studies, and SOC 2 to reach the credibility floor that enterprise buyers need.
- **Crawlee v4 (Rust rewrite, RC since Aug 2026) may change the fork-point.** If v4 ships stable before the team's MVP, the fork should target v4 for long-term alignment; if not, fork v3 and plan migration.
