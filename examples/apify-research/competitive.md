# Competitive Analysis — Apify & the AI-Agent Scraping-API Landscape (RQ6/RQ7 feed)

Slug: `apify` · Date: 2026-09-08 · Agent: competitive-analysis (big-pickle)
Inputs: plan.md, github.md, web.md, reddit.md (channel unavailable — no Reddit sentiment used) + supplemental web search for competitor pricing/positioning (sources below).
Confidence: A = primary (vendor page/docs/repo), B = reliable secondary (corroborated third-party), C = inferred.

---

## Summary (conclusion first)

Apify is the scale anchor but scores **worst on pricing transparency (2/5)** of any profiled player — that gap is the entire wedge conversation, and it is already being attacked: **Firecrawl (AI-native, AGPL, ~$16 entry) slightly out-scores Apify on a wedge-weighted index, and Context.dev (YC S26, solo founder, 1 credit = 1 scrape, flat billing) launched Jul 2026 into exactly the "simplest possible agent scraping API" lane**. The high-AI-agent-DX × high-billing-simplicity target quadrant is therefore **not empty** — a nearly identical player already sits in it, which raises the bar for differentiation to vertical focus, permissive open-core self-host, and a transparency/trust brand. A small team should **compete, narrowly**: do not rebuild breadth; the defensible openings are (1) a vertical agent-data wedge, (2) task-based honest billing as identity, (3) a genuinely permissive (Apache/MIT) self-hostable agent-scrape core — all three exploit Apify's documented weak points, and the last two Apify structurally cannot follow without cannibalizing its cloud.

---

## 1. Landscape summary

**Category frame (2026):** web-scraping-as-API is splitting into two camps (web.md Q6, B): **AI-native, API-first** tools that output LLM-ready markdown/JSON and speak MCP natively (Firecrawl, Context.dev, Jina, Crawl4AI), vs **platform/marketplace + proxy-infra** incumbents (Apify, Bright Data, Oxylabs, Zyte, ScraperAPI) that are bolting MCP/agent layers onto metered infrastructure. Market: web scraping software ~$1.56B (2026) → $3.49B (2031, 17.4% CAGR); AI agents ~$7.8B (2025) → $52.6B (2030, 46.3% CAGR) (toolproven-cited Mordor/MarketsandMarkets, B).

**Structural fact that shapes everything** (github.md, A): Apify's entire crawl engine + SDKs + MCP layer are **Apache-2.0/MIT and forkable today**; its moat (Actor Store ~8k–52k actors, hosted storage/queues, proxy network, compute-unit billing, hosted MCP) is **closed**. Firecrawl's core is AGPL-3.0 with the anti-bot "fire-engine" **cloud-only**; Browserless is **SSPL-1.0 source-available** (commercial self-host = paid license); Context.dev, ZenRows, ScraperAPI, Bright Data are closed SaaS. **Nobody in the set offers a genuinely permissive (Apache/MIT) self-hostable agent-scraping API with a managed tier** — that lane is open, and open-source single-binary substitutes (fastCRW-class, AGPL Rust with Firecrawl-compatible APIs) are already commoditizing the self-host floor.

**2026 inflection:** MCP is now table stakes — Apify, Firecrawl, ZenRows, Browserless, Bright Data, and Context.dev all ship MCP servers (A/B). The next differentiators are (a) billing legibility (Context.dev's flat credit, ZenRows' pay-only-for-success), (b) agentic payments (Apify joined x402 Jun 2026, B), and (c) vertical depth — where nobody has claimed a lane yet (C, inferred from positioning review of all profiled players).

**Reddit sentiment:** channel unavailable this run (reddit.md). No community-derived sentiment is used; pain-point evidence instead comes from third-party pricing explainers (web.md) and vendor comparison pages. Flagged as a coverage gap for analysis.

---

## 2. Competitor tiers

Scoping consequence (from plan.md): "we" = solo/small team; compete = niche wedge (AI-agent-native API, self-host/open-core, vertical focus, pricing simplicity). Direct tier = same-band players contesting that wedge; adjacent = models to copy or get squeezed by; aspirational = the scale/moat bar — including Apify, the attack target itself.

| Tier | Player | Why it's here | One-line position (their words / observed) |
|---|---|---|---|
| **Target / anchor** | **Apify** | The benchmark: the platform we'd attack; also the Aspirational scale bar (200+ staff, marketplace, moat) | "The largest marketplace of trusted tools for AI" (apify.com, A) |
| **Direct** | **Firecrawl** | Same wedge (AI-agent scraping API), small-team scale, YC-backed, AGPL self-host | "The context API to search, scrape, and interact with the web" (firecrawl pricing page cited by toolproven Jul 2026, B) |
| **Direct** | **Context.dev** | The closest mirror of the hypothesized wedge: solo founder, YC S26, flat 1-credit billing, MCP | "The context layer for the internet… one API that helps agents understand websites" (toolproven Jul 2026, B) |
| **Direct** | **ZenRows** | API-first anti-bot challenger built on "no surprise invoices" billing semantics | "No parameter tuning. No broken scrapers… No surprise invoices. Just data." (zenrows.com vs-ScraperAPI, B) |
| **Adjacent** | **Browserless** | The self-host/source-available model reference (open-core-with-teeth); also a substitute (build on it) | "Browser infrastructure that scales with you" (browserless.io, A) |
| **Adjacent** | **ScraperAPI** | Old-guard mid-tier volume API; shows the credit-multiplier pricing pattern Apify shares | "Data collection at scale" — managed proxies + structured endpoints (browse.ai comparison, B) |
| **Adjacent / substitute** | **Self-hosted Crawlee stack** | Not a company: the Apache-2.0 foundation any competitor (incl. us) builds on — and the "build it yourself" alternative users pick instead of paying | Crawlee 25.7k★/9.5k★, 621k npm dl/mo (github.md, A) |
| **Aspirational** | **Bright Data** | Enterprise web-data/proxy empire; the commercial-credibility and unblocking bar | "Your AI agent's gateway to the web" — Web MCP (brightdata.com/pricing/mcp-server, A) |

*Dropped for tightness:* Oxylabs/Zyte (same aspirational class as Bright Data, weaker AI-agent evidence in scope), ScrapingBee (mid-tier clone of ScraperAPI), Browse AI (no-code, different buyer), Browserbase/Steel/Stagehand (browser-infra-for-agents — overlapping but the task scoped Browserless as representative; noted in landscape as adjacent threat vector, C).

---

## 3. Scoring matrix (weighted, wedge-lens)

### Dimensions & weights (sum = 100%)

Weights are loaded toward the plan's wedge axes (pricing simplicity + AI-agent readiness = 36%) — this matrix answers "who is beatable **for our kind of wedge**", not "who is biggest".

| # | Dimension | Weight | Rationale |
|---|---|---|---|
| 1 | Positioning clarity & distinctiveness | 14% | Wedge requires an ownable position in a crowded field |
| 2 | Offer packaging | 12% | Can they package a legible product, or is it sprawl? |
| 3 | Pricing transparency & simplicity | 18% | Apify's #1 documented complaint; our wedge pole A |
| 4 | AI-agent readiness | 18% | MCP/LLM-output/agent-native ergonomics; our wedge pole B |
| 5 | Evidence & trust | 12% | Small players must win trust; incumbents have receipts |
| 6 | Enterprise-readiness | 10% | Ceiling on how far a product can scale |
| 7 | Developer experience | 10% | The buyer IS a developer here |
| 8 | Open-source posture | 6% | Forkability/self-host lane (plan wedge option) |

### Score grid (1–5; confidence in parens; \* = inferred)

| Player | Positioning (14) | Packaging (12) | Pricing trans. (18) | AI-agent (18) | Evidence (12) | Enterprise (10) | DX (10) | OSS (6) |
|---|---|---|---|---|---|---|---|---|
| **Apify** (target) | 4 (A) | 5 (A) | **2** (A/B) | **5** (A) | 4 (A/B) | 4 (B) | 4 (A/B) | 4 (A) |
| **Firecrawl** | 5 (B) | 4 (B) | 3 (B) | **5** (A/B) | 4 (B) | 3 (B) | 4 (B) | 4 (B) |
| **Context.dev** | 4 (B) | 3 (B) | **5** (A/B) | 4 (B) | **2** (B) | 2 (B) | 4 (B) | 2 (C\*) |
| **ZenRows** | 4 (B) | 3 (B) | 4 (B) | 3 (B) | 3 (B) | 2 (C\*) | 4 (B) | 1 (C\*) |
| **ScraperAPI** | 3 (B) | 4 (B) | 2 (B) | 2 (B) | 4 (B) | 4 (B) | 3 (B) | 1 (C\*) |
| **Browserless** | 3 (B) | 4 (B) | 3 (B) | 3 (B) | 3 (B) | 3 (B) | 4 (B) | 3 (B) |
| **Self-host Crawlee** | 2 (C\*) | 1 (C\*) | **5** (A) | 2 (C\*) | 4 (A) | 1 (C\*) | 4 (A) | **5** (A) |
| **Bright Data** | 4 (A/B) | 5 (A) | 2 (B) | 3 (A/B) | **5** (A/B) | **5** (A/B) | 3 (B) | 2 (C\*) |

### Score rationale (one line per score, with source)

**Apify** — 4: position "marketplace of trusted tools for AI" is clear and ownable but sprawling across marketplace+infra+agents (apify.com, A). 5: Actors+Store+proxies+storage+MCP+agent templates — deepest surface in set (web.md Q3, A). **2: prepaid CU credits + proxy $/GB + storage + actor fees stack into unpredictable bills — the category's most-cited complaint ("sticker price isn't the price"); plan price churn $19→$29→$49 reported 2026** (web.md Q1, A via apify.com/pricing + B via toolproven/crawlcrawl; C on churn readings). 5: apify-mcp-server 6.3k★/122k npm dl, LangGraph/CrewAI/LlamaIndex/Mastra/Haystack/OpenAI-Agents integrations, agent templates, x402 (github.md Q5 A; web.md Q3 B). 4: SOC2-II/GDPR/99.95% + named enterprise logos (B), but revenue private, 2023 only primary disclosure (A/B). 4: Business tier + account manager + enterprise custom (A), but support is community/chat until upper tiers (B). 4: Crawlee DX + 7-language SDKs + CLI (A); compute-unit mental model a documented drag (B). 4: Apache-2.0/MIT OSS leadership, but 3 flagship repos unlicensed (agent-skills, actor-templates, super-scraper) and cloud closed (github.md Q3, A).

**Firecrawl** — 5: sharpest AI-native position; retitled "context API" (B). 4: clean endpoints /scrape /crawl /map /extract /search /agent + MCP + multi-language SDKs; no marketplace, no workflow builder (B). 3: headline "1 credit/page" is simple, but modifiers stack (JSON +4, prompt-injection +4, ZDR +1, PDF +1; stealth 5×) and AI Extract bills separately from ~$89/mo = documented "hidden extract bill" (B, dev.to teardown 2026-05; fastcrw 2026-06; toolchase 2026-09). 5: native MCP, /agent autonomous endpoint, LLM-ready output by design (A/B). 4: YC-backed, 130–176k★, dated public benchmarks, SOC2-T2 claimed; star-count partly marketing (B). 3: SOC2-T2 + SSO/ZDR on Enterprise, self-serve Scale $599–749, but no named enterprise logos in evidence; self-host ≠ cloud features (B). 4: docs/playground/CLI + agent-native onboarding (auth.md/SKILL.md) (B). 4: AGPL-3.0 core (real OSS, honest SELF_HOST.md about limits) but copyleft + fire-engine cloud-only (B).

**Context.dev** — 4: "context layer for the internet" with flat-billing identity is sharp; brand unproven (B). 3: one API + brand/entity data + MCP + monitors; no marketplace, no browser automation, docs/pricing mismatch (B). **5: "1 credit = 1 scrape, residential proxies/JS/anti-bot included, no hidden surcharges; failed requests not billed; no overage free tier" — best billing-legibility in set** (A/B via context.dev/pricing + toolproven). 4: LLM-ready markdown/JSON + hosted MCP + SDKs (TS/Py/Go/Ruby/PHP); no interact/agent endpoint (B). **2: solo founder, 8 PH reviews, zero Reddit/G2/Trustpilot, vendor-stated logos unverified, SOC2-T1 only, SLA only on Enterprise** (B, toolproven caveats). 2: same evidence limits (B). 4: 10-minute integration, simple REST, clear credit table (A/B). 2: "open-source core" claimed but no repo found — effectively closed (C\*).

**ZenRows** — 4: "out of the box, no surprise invoices" — clear challenger position vs complex incumbents (B). 3: single API + scraping browser + mode:auto (B). 4: bills only successful requests, protected sites 25× base (published; 3× cheaper than ScraperAPI's 75×), but still multiplier credits + geo surcharges (B). 3: MCP server yes (B), AI Web Unblocker, but no agent/autonomous endpoint — anti-bot API first (B/C\*). 3: Capterra 4.8 / Trustpilot 3.4 mixed; independent 60-day test bench credible (B). 2: no SOC2/SLA evidence gathered; plans top ~$299 (C\*). 4: mode:auto removes config guessing = real DX win (B). 1: closed SaaS (C\*).

**ScraperAPI** — 3: "scale" infra position, generic (B). 4: API + 20+ structured endpoints + DataPipeline + LangChain (B). 2: 1–25× complexity credits, ultra-premium 75× with render, 8 tiers, May-2026 restructure with top tier +315% (B, costbench). 2: LangChain only; raw HTML out; no MCP/agent endpoint in evidence (B). 4: 99.99% claim, 10k+ companies, 40M+ IPs, Trustpilot 4.7 (B). 4: 8 tiers to $1,975 + enterprise custom + 150 geos (B). 3: simple API/docs but config-guessing standard/premium/ultra is the documented pain (B). 1: closed SaaS (C\*).

**Browserless** — 3: "browser infrastructure that scales with you" — clear but utility-flavored (A/B). 4: BaaS (Puppeteer/Playwright wss) + REST + BrowserQL stealth + MCP + Stagehand/LangChain/n8n/Make/Zapier + self-host Docker (B). 3: usage units + concurrency; free 1k units, $25 proto, ~$350 scale; stealth/proxy metered separately; enterprise custom (B). 3: MCP + captcha solving + BrowserQL, but you still write the agent logic (B). 3: bootstrapped since 2017, ~$4M ARR self-reported, 13.3k★, 4.47/150 reviews (B). 3: enterprise plan w/ SSO + custom machines; SSPL license friction (B). 4: drop-in endpoint swap for Puppeteer/Playwright, good docs, active changelog (B). 3: source-available SSPL-1.0/commercial — self-hostable but not permissive (B).

**Self-hosted Crawlee stack** — 2: no positioning; a library (C\*). 1: no packaged offer — you assemble runtime/storage/API/proxy/billing (C\*). 5: cost = your infra; the ultimate price floor and risk cap (A/C\*). 2: crawl primitives only; no MCP/agent layer out of box (apify-mcp-server is platform-bound) (A/C\*). 4: 25.7k★/621k npm dl/2,280 dependents — massive trusted OSS, but the trust accrues to Apify's brand (A). 1: no SLA/support; you own everything (C\*). 4: genuinely good DX (sessions, fingerprints, storage abstractions) (A). 5: Apache-2.0, forkable, weekly releases (A).

**Bright Data** — 4: enterprise web-data platform identity, now "your AI agent's gateway to the web" (A/B). 5: proxies + Web Unlocker + Scraping Browser + SERP + datasets + 100+ domain structured endpoints + MCP — widest surface (A). 2: per-product commitments (~$499/mo minimum each → ~$998 floor for two), per-GB/per-request/per-session metering, sales-led (B, use-apify; context.dev blog). 3: official Web MCP ($1.5/1K, 5K free) + LangChain/LlamaIndex/OpenAI; but raw HTML default, infra-first (A/B; Context.dev's "None documented" claim is stale — primary page wins). 5: 50k+ customers, GDPR/CCPA, Capterra 4.8, long track record (A/B). 5: SSO, compliance, 99.99%, AWS Marketplace, AMs — the enterprise bar (A/B). 3: SDKs/docs fine but sales-led, multi-product billing console friction (B). 2: brightdata-mcp on GitHub; platform otherwise closed (B/C\*).

### Tension plot (dimension 9 — the client's strategic tension, reported separately, never averaged)

Axes from plan.md's wedge: **X = AI-agent-native DX** (LLM-ready output, MCP/agent ergonomics; 1 = raw HTML infra, 5 = agent-native by design) × **Y = pricing simplicity/predictability** (1 = stacked metered surprise, 5 = flat, no-surprise semantics).

```
Y: pricing simplicity
5  │  Self-host Crawlee┐  Context.dev  ← TARGET QUADRANT (high × high)
   │                   │
4  │                   │  ZenRows
   │                   │
3  │        Browserless│  Firecrawl
   │                   │
2  │  ScraperAPI /     │  Apify
   │  Bright Data      │
1  │                   │
   └───────────────────┴──────────────→ X: AI-agent-native DX
      1       2        3       4       5
```

**The single most important finding:** the target quadrant (high AI-agent DX × high billing simplicity) is **not empty — Context.dev sits in it** (X4, Y5) as of Jul 2026, and Firecrawl is one step away (X5, Y3, dragged only by its extract-billing complexity). Apify is the pure high-X/low-Y pole — the flank we attack. Anyone entering must be sharper than "flat price + MCP", because that sentence is now Context.dev's entire pitch.

### Indicative weighted index (scan aid — NOT a verdict; see tension plot)

Apify 3.94 · Firecrawl 4.04 · Bright Data 3.58 · Context.dev 3.50 · Browserless 3.22 · ZenRows 3.20 · Self-host Crawlee 2.94 · ScraperAPI 2.86.
Reading (wedge lens): **Firecrawl edges Apify even weighted toward our axes; Apify's #3 position is carried by breadth while its pricing (2) is the exposed flank; Context.dev's index is dragged down solely by trust/enterprise (2/2) — a reminder that billing simplicity alone does not close enterprise deals.** These weights reflect a small-team wedge lens (36% on pricing+AI-agent), not an absolute market ranking.

### Deep dives (the instructive four)

- **Apify (the attack target):** breadth king, profitable, capital-efficient, hyperactive OSS + agent distribution. Its vulnerability is structural: every revenue stream is metered (CU + proxy GB + storage + actor fees), so it cannot simplify billing without shrinking ARPU — a flat-pricing competitor cannot be matched cheaply. Its marketplace quality variance (52k actors, concentrated payouts, $760k/mo dev payouts) is the trust flank. (web.md A/B; github.md A)
- **Firecrawl (the exemplar):** proves an AI-native API + honest-self-host story can out-score Apify on wedge-weighted terms from a small-team base. Its weak point (extract dual-billing) shows even the AI-native leader fell into the multiplier trap — that's the exact mistake a newcomer should avoid. (B)
- **Context.dev (the cautionary + the signal):** confirms the wedge is viable (solo founder, #1 Product Hunt, YC S26) and that demand for flat agent-scrape billing is real — but its trust gap (no reviews, no SLA, vendor-stated logos) is why a small team can still win on evidence/transparency rather than price alone. (B)
- **Self-hosted Crawlee (the foundation and the trap):** Apache-2.0 gives us legally safe building blocks, but building our brand on Apify's library means our roadmap is governed by Apify's releases — and Apify's unlicensed repos (agent-skills, actor-templates, super-scraper) must not be forked. (github.md A)

---

## 4. White space (where a small team can realistically enter)

Mapped from Apify's documented weak points (web.md/github.md); inferences flagged \*.

1. **Complex platform for simple needs → the "micro wedge" is occupied but not saturated.** Context.dev and Firecrawl already serve "one call, clean data, no compute-unit mental model." Flag: partially occupied (B). The residual gap is *simplicity plus depth*: a single flat API that also does what Context doesn't (browser interact) and what Firecrawl bills confusingly (extraction) — i.e., simple billing AND full capability in one surface. Nobody holds both today (C\*).

2. **Unpredictable billing → task-based pricing + radical transparency (the identity play).** Apify's #1 complaint (web.md, B); ZenRows/Context chip at it but nobody has made *published cost math* and *pay-per-completed-task* the brand. This is cheap for a small team to do (zero infra commitment, just pricing design) and Apify structurally can't follow (C\* on Apify's inability — inferred from its ARPU structure). Pairs naturally with Apify's x402/pay-per-use direction: be the agentic-payments-first, per-task-priced tool rather than per-CU.

3. **Marketplace quality variance → curated/quality-gated vertical (the trust wedge).** Apify sells breadth (15k–52k actors, quality varying; dev payouts concentrated → long tail of weak actors, C\*). No profiled player positions on *curated, maintained, quality-gated scrapers with a freshness SLA*. A vertical (e.g., e-commerce pricing for AI shopping agents, SERP for a niche, real-estate listings) owned end-to-end: 5–10 excellent maintained tools + honesty about coverage + flat pricing. Nobody in the set occupies this (C\*).

4. **AI-agent pivot crowding → MCP is table stakes; the next layer is open.** Every player ships MCP (A/B). The open lane is *permissive-license self-hostability*: Apache/MIT core (Crawlee base or own runtime), self-host floor caps customer risk (fastCRW/Firecrawl prove the pattern), managed tier pays the bills. Apify can't follow (cloud cannibalization), Bright Data/ScraperAPI structurally can't, Firecrawl is AGPL-with-closed-fire-engine, Browserless is SSPL-paid. This is the most defensible, least-crowded lane — and the hardest to operate (support/docs/distribution burden). Partially occupied by fastCRW-class single-binary tools (B) — enter with a managed tier + vertical focus, not "another AGPL binary".

5. **Trust/transparency optics (open, cheap, underused).** Combined with the above: the anti-Apify brand — published unit-cost math, honest failure handling, pay-only-for-success, no silent multiplier reclassification (a documented gotcha for credit-multiplier APIs — dataresearchtools, B). Cheap for a small team; nobody owns it as identity (C\*).

**Summary of the smallest credible wedge (per plan.md posture):** a **vertically focused, MCP-native agent-data API with flat per-task pricing, an Apache/MIT self-hostable core, and published cost math** — entering on the pricing-transparency flank (Apify 2/5) with a trust/quality story the marketplace players structurally can't copy. Avoid: generic scraping API, unblocking-at-scale (residential proxy economics favor Bright Data/Apify — the hard, capital-heavy component, C\*), and anything needing enterprise procurement early (Context.dev shows the trust gap there).

---

## 5. Verdict direction (input to analysis; final verdict is analysis's)

**Recommendation: compete — narrowly, with a clock.** Four evidence-backed reasons:

1. **The wedge is real and demand-side proven:** web.md shows the market growing (scraping 17.4% CAGR; agents 46.3%) and Context.dev — a solo founder at YC S26 — hit #1 Product Hunt in Jul 2026 with literally this pitch. Where a solo founder already lands, a small team can too (A/B).
2. **The wedge is beatable on its weakest axis:** Apify scores 2/5 on the very dimension (pricing transparency) that is its #1 complaint, and its business model structurally prevents it from fixing that (C\* on structural inference). Firecrawl's extract dual-billing shows the AI-native leader repeating the same mistake (B).
3. **The legal floor is friendly:** the entire crawl runtime is Apache-2.0 and forkable today (github.md A) — but do NOT build on Apify's unlicensed repos, and avoid the "self-host generic scraper" lane already commoditized by fastCRW-class tools (B).
4. **But the cheap version of the wedge is taken:** flat-price + MCP is Context.dev's pitch; generic AI-native scraping is Firecrawl's. **Differentiate on the combination: vertical focus + permissive open-core + transparency as brand.** Expect Context.dev-class entrants to keep coming; 9-month clock before the high/high quadrant is genuinely crowded (C\*).

**Don't-compete conditions:** if the team can't commit to a vertical (needs domain data access/maintenance) OR to running a self-host open-core (docs/support/distribution), the remaining differentiation (pricing alone) is too thin against Context.dev/Firecrawl — in that case, don't compete; partner instead (e.g., build on Crawlee/proxy vendors rather than against them).

---

## 6. Sources

Primary (A):
- apify.com/pricing, docs.apify.com (via web.md) — Apify plans, CUs, proxies, free tier
- GitHub API — `apify/*` repos, licenses, activity, downloads (github.md)
- brightdata.com/pricing/mcp-server, /pricing/web-unlocker — Bright Data MCP + Web Unlocker pricing (fetched 2026-09-08)
- browserless.io/pricing, browserless.io/blog/browserless-vs-browserbase (2026-08-17)
- context.dev/pricing, context.dev/web-scraping-api, context.dev/compare (fetched via search 2026-09-08)
- zenrows.com/pricing, zenrows.com/products/universal-scraper/zenrows-vs-scaperapi

Secondary (B):
- toolproven.com/blog/context-dev-review (2026-07-13) — Context.dev vs Apify vs Firecrawl table, trust caveats
- costbench.com/software/web-scraping/scraperapi — 8-tier pricing, May 2026 restructure (+315% top tier)
- dev.to/beton/firecrawl-pricing-teardown-2026 (2026-05-27) — Firecrawl extract dual-billing (~$89/mo AI Extract)
- fastcrw.com/blog/firecrawl-pricing-explained (2026-06-06) — credit math, free-tier one-time grant, self-host escape valve
- toolchase.com/tool/firecrawl (2026-09-03) — 176k★, modifier stack (JSON +4, PI +4, ZDR +1, PDF +1), SOC2-T2, honest self-host docs
- dataresearchtools.com/scraperapi-vs-zenrows-vs-scrapingbee — 60-day bench; credit-multiplier gotchas; ZenRows best Cloudflare bypass
- use-apify.com/blog/bright-data-pricing-guide-2026 (2026-03-15) — Bright Data per-product commitments, $8.40/GB PAYG residential
- use-apify.com/blog/best-ai-web-scraper-2026 (2026-03-19) — price/1K pages table, Bright Data ~$0.10/h scraping browser
- tooldirectory.ai/tools/browserless (2026-07-24) — bootstrapped ~$4M ARR, SSPL-1.0, 13.3k★
- stork.ai/en/browserless — Browserless capabilities/MCP/integrations snapshot
- costbench/use-apify/toolproven/crawlcrawl — Apify pricing-literacy complaints (mutually corroborating; web.md Q1)
- firecrawl.dev/blog/scraperapi-alternatives (2026-03-02) — vendor head-to-heads (Firecrawl/ScraperAPI) — treat marketing-flavored claims as B
- MyMCPTools/Toolradar — Firecrawl plan verification (Sep 2026)
- aiagentswatch.com/posts/zenrows-pricing (2026-08-23) — ZenRows credit plans, AI-agent fit

Inferred (C, flagged \*): Apify's inability to flatten pricing without ARPU damage; marketplace long-tail quality variance; vertical lane emptiness; Context.dev/ZenRows/ScraperAPI/Bright Data open-source absences; self-host Crawlee non-positioning. Reddit-derived sentiment: **none** — channel unavailable (reddit.md); the RQ5 gap stands.

### Verification / bias notes
- Vendor self-claims (SOC2, star counts as credibility, "10,000+ companies") are marked B where uncorroborated; asserted ≠ proven.
- Bright Data MCP: Context.dev's blog claims "None documented" (B, self-interested); primary brightdata.com MCP pricing page (A) wins — stale cross-vendor comparisons are a known trap in this category.
- Firecrawl star counts range 130k (Mar 2026, vendor) → 176k (Sep 2026, reviewer); treated as directional B.
- Apify plan price reads $19 (primary today) vs $29–$49 (third parties, mid-2026) — flagged C; verify live before any go/no-go.