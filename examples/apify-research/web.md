# Web Research — Apify business model, pricing, company, positioning (RQ1 + RQ4 feed)

Date: 2026-09-08 · Channel: web-research · Confidence: A = primary (apify.com/docs/press), B = reliable secondary (multi-source corroboration), C = inferred/estimate

## Summary (conclusion first)

Apify is a **privately held, bootstrapped-then-lightly-funded, profitable web-data platform** headquartered in Prague (CZ), founded 2015 by Jan Čurn and Jakub Balada out of Y Combinator's Fellowship. It has raised only **~$3.0–3.5M total** (last round Seed, Apr 2024, €2.8M led by J&T Ventures + Reflex Capital); no valuation is disclosed. Publicly disclosed earnings are **€6.7M revenue (~€1M profit) in 2023** (Boosted/tech.eu); third-party estimators place 2024 revenue at $13.3M ARR (GetLatka, B) or ~$14.7M (Prospeo, B). Headcount climbed from ~75 (2023) → ~116 (Dec 2024) → **~201–231 (2026)** across sources (B). Positioning has **pivoted decisively to AI**: "largest marketplace of trusted tools for AI", the Actors-MCP server, native integrations with LangGraph/CrewAI/LlamaIndex/Mastra/Haystack/OpenAI Agents, agent templates, and the June 2026 x402 agentic-payments push. The moat is the **Actor Store marketplace (now ~8k–50k+ tools depending on definition/date)** + hosted runtime/proxies/billing — all closed/proprietary (see github.md). Pricing is a **consumption-metered prepaid-credit model** (Compute Units + proxy GB + storage), not a flat send-per-result SaaS — this is the single biggest "pricing complexity" complaint and therefore a wedge opening.

## Q&A

### Q1. Pricing model (free tiers, Compute Units, proxies, storage, actor revenue share)

**Plans (fetched primary, apify.com/pricing, 2026-09-08, A):** Free $0 ($5 prepaid usage, $0.20/CU, 16 GB RAM, 5 concurrent runs, community support); Starter **$19/mo** ($17 annual, $19 prepaid, $0.20/CU, 64 GB, 32 runs, Bronze store discount, chat support); Scale $199/mo ($179 annual, $199 prepaid, $0.16/CU, 256 GB, 128 runs, Silver); Business $999/mo ($899 annual, $999 prepaid, $0.13/CU, 512 GB, 256 runs, Gold, account manager). Enterprise custom. URL: https://apify.com/pricing (fetched today; A).

**Compute Unit definition (A):** 1 CU = 1 GB of RAM running 1 hour. E.g. a 4 GB actor for 15 min = 1 CU. Per-CU rate drops by tier: Free/Starter $0.20, Scale $0.16, Business $0.13. Source: apify.com/pricing + docs.apify.com (A).

**Proxy (A, apify.com/pricing):** Residential proxy $8/GB (Free/Starter), $7.5 (Scale), $7 (Business). Datacenter proxy: 5 IPs included (Free), 30 IPs incl. then $1/IP (Starter), 200 then $0.80/IP (Scale), 500 then $0.60/IP (Business). SERPs proxy $2.5–$1.7 per 1,000 SERPs; Unblocker $1.5–$1.0 per 1,000 requests. Datacenter proxy from $0.6/IP as add-on.

**Add-ons (A, apify.com/pricing):** Concurrent runs $5/run (extra), Actor RAM $1/GB, personal training $150/hour.

**Storage/data-transfer (A):** not itemized on the page body; the FAQ states read/write to a run's dataset after the run finishes counts as platform usage, and storage/data-transfer are usage-charged platform services (billed against the prepaid credit). Docs: https://docs.apify.com/actors/running/usage-and-resources.

**Actor revenue-share / Store economics (A, docs):** Store Actors use two models — **pay-per-event** (developer sets a fixed price per defined event; platform usage may be bundled or billed separately) and **pay-per-usage** (dev charges nothing; only platform usage billed). **Rental model is being retired**: no new rental Actors after Apr 1 2026; all remaining rentals migrate to pay-per-usage by Oct 1 2026. Source: https://docs.apify.com/actors/running/actors-in-store (A) + https://docs.apify.com/actors/publishing/monetize/rental.

**Developer payouts (B):** Apify Store paid out **$760,000 to developers in January 2026** (press release, Feb 19 2026) — a concrete signal of marketplace volume. URL: https://www.einpresswire.com/article/893752914 (B; EIN syndication of Apify press release).

**Third-party pricing-literacy problem (B):** Multiple independent explainers (scrapewise 2026-06-25, toolproven 2026-08-01, crawlcrawl 2026-05-23, dailyaifixs 2026-08-18) all hammer the same point: "sticker price isn't the price" — bills stack compute + proxy + paid-actor fees, and heavy jobs blow through the prepaid credit, causing surprise overages. This is the platform's most-cited pricing complaint. Confidence B because these are secondary aggregators, but they're mutually corroborating and match the primary pricing page's structure. URL examples: https://toolproven.com/blog/apify-pricing-explained (2026-08-01), https://crawlcrawl.com/blog/apify-pricing (2026-05-23).

> **Note on price discrepancy:** apify.com/pricing (fetched today, A) shows **Starter $19**; several third parties (toolproven 2026-08-01, costbench 2026-08-03, automationatlas 2026-07-23) report **$29**, and scrapegraphai reports $49. This suggests plan-price churn during 2026. I treat apify.com's current $19 as the current primary truth (A) and flag the $29 as a possibly-recent (or regional) figure (B). Any competitor pricing model must verify live.

### Q2. Company: founded, funding, valuation, headcount

**Founded:** 2015 by Jan Čurn and Jakub Balada, launched as "Apifier" via the inaugural Y Combinator Fellowship (Mountain View) on Oct 20, 2015; moved to Prague in 2016. Primary: https://apify.com/about ("Founded in 2015", "Y Combinator Fellowship in Mountain View, California") (A) + https://blog.apify.com/apify-origin-story (2025-10-20) (A).

**Funding / valuation:** Total raised **~$3.0–3.5M across 4–5 rounds** (small YC-Fellowship grant Oct 2015 ~$12k; seed ~$250k Nov 2016 InCOMMing; ~$130k Jun 2018 Reflex Capital; $3.0M/€2.8M Seed Apr 2024 led by J&T Ventures + Reflex Capital). No public valuation. Sources: Tech.eu 2024-04-15 (A) https://tech.eu/2024/04/15/prague-startup-apify-raises-eur28m-for-ai-data-mining; Crunchbase/Tracxn/Seedtable (B): https://tracxn.com/d/companies/apify, https://seedtable.com/companies/apify/funding-rounds. GetLatka says $3.5M total (B): https://getlatka.com/companies/apify. **Y Combinator** is a listed investor (B).

**Revenue / profitability (primary disclosure):** €6.7M revenue and ~€1M profit in 2023; "grown profitably since 2019"; 80% Q4-2023 YoY revenue growth; last investment before 2024 was 2019 (i.e. profit-funded for years). CEO Jan Čurn, via Tech.eu 2024-04-15 (A). **Estimated 2024 ARR:** $13.3M (GetLatka, estimated, B) / $14.7M (Prospeo, B). Estimates only — actual revenue is private. GetLatka: https://getlatka.com/companies/apify; StartupMap corroborates €6.7M/2023: https://startupmap.one/startup/apify_cz.

**Headcount:** ~75 (2023) → ~116 (Dec 2024) → **~201–231 (2026)**. GetLatka: 231 (Apr 2026, B) https://getlatka.com/companies/apify; Caplight signal: grew 51% QoQ from 133 to 201 employees (Feb 2026, B) https://www.caplight.com/company/apify; LeadIQ: 201–500 (B). Still actively hiring (12–13 open roles, Seedtable/Glassdoor 2026-09, B).

**Acquisitions:** none found (Owler: "no acquisitions", B; thecompanycheck: none).

**HQ:** Prague, Czechia; offices also in Brno; legal entity Apify Technologies s.r.o. (A, https://www.thecompanycheck.com/company/b/apify, https://apify.com/jobs).

**Customers:** Siemens, Microsoft, Intercom, Groupon, T-Mobile, Accenture (Tech.eu/StartupMap, B); European Commission (price monitoring across 800+ retailers, Grokipedia, B); 25,000+/40,000 users. Prospeo cites "10,000+ customers" and 4.8/40,000 users (B, https://prospeo.io/c/apify-revenue). Customer-count figures vary widely by source (10k–40k) — treat as directional (C).

### Q3. Product surface today (Actors, Store size, Crawlee, Apify AI/agents, MCP, integrations)

**Positioning now (A):** apify.com homepage tagline = **"Apify: The largest marketplace of trusted tools for AI"** — the company explicitly frames itself as an AI-tools marketplace, not just a scraper. AI-agents landing page: https://apify.com/ai-agents ("Connect your AI agents to fresh web data using thousands of ready-made scrapers. Publish and monetize agents directly through the Apify platform"). Feb 2026 press release: "web data and automation platform for AI builders" (B).

**Actor Store size (variance — the key numbers vs date):**
- "over 1,500 Actors" (Tech.eu, Apr 2024, A-era).
- "over 15,000 Actors" (Apify press release, Feb 19 2026, B).
- "20,000+ actors" (third-party store-scraper analysis, Mar 19 2026, B): https://liaichi.substack.com/p/i-analyzed-20000-apify-actors-heres.
- "30,000+" (use-apify + toolproven, Mar–Aug 2026, B) — multiple 2026 comparators cite 30k–52k.
- "52,000+" (toolproven, Jul 12 2026, B): https://toolproven.com/blog/web-scraping-for-ai-agents.
- x402 release (Jun 30 2026, B) says adding "more than 20,000 tools" to the "2,000 currently available" on x402 — implying ~22k+ total catalog.
**Reading:** the catalog has grown from ~1.5k (2024) to tens of thousands (2026) — rapid, but exact numbers are inconsistent (definition differs: all-listed vs premium/paid vs x402-eligible). Treat exact count as **C**. The trajectory of "3-30x growth in 2 years" is the defensible claim (A for direction, C for magnitude). Top-actors volume: Google Maps Scraper 571k users, Instagram 371k, TikTok 242k (use-apify, read from Store API 2026-08-22, B).

**Apify AI (A):** natural-language interface inside Apify Console to find/run Actors. https://docs.apify.com/account/apify-ai.

**MCP story (A/B):** official apify-mcp-server (MIT per github.md) + hosted endpoint mcp.apify.com (OAuth + agentic payments). Native MCP support to let agents discover/run Actors. https://docs.apify.com/platform/integrations/mcp. 2026-06-11: "Apify announces MCP connectors" — Actors can access third-party apps (Notion, GitHub, Slack) via user's own account (B, https://cbherald.com/apify-announces-mcp-connectors/).

**Agent-framework integrations (A):** LangGraph, CrewAI, Mastra.ai, LlamaIndex, Haystack, OpenAI Agents SDK, plus LangChain — documented at https://apify.com/ai-agents and docs.apify.com/platform/integrations/*. RAG-web-browser flagship Actor (github.md).

**x402 / agentic payments (B):** Jun 30 2026 press release — Apify adds 20,000+ tools to the x402 standard (Coinbase) so agents can pay for tools autonomously with no account/API key; CEO quote: "build Apify into the largest and most trusted marketplace of tools for AI." https://mergersacquisitions.einnews.com/pr_news/923244179 (EIN syndication, B).

### Q4. 2024–2026 trajectory / AI pivot evidence

- **2024-04:** €2.8M seed (AI data mining framing). Tech.eu (A).
- **2024-07:** Crawlee for Python launch. Owler/Benzinga (B).
- **2025-04:** partnered with Lindy (4,000+ scrapers surfaced to AI agents); 4,000 actors exposed via MCP to Claude. RivalSense (B).
- **2025-05:** Crawlee upgrade making Python first-class (B).
- **2026-02:** G2 2026 Best Software #8 in IT Management; >15,000 Actors; $760k monthly dev payouts; "platform for AI builders". EIN/aiTHORity (B).
- **2026-06:** MCP connectors (B); x402 agentic payments (B).
- **2026 adoption:** crawlee 621k npm/dl, mcp-server 122k/dl (github.md, A); 2,280 dependent repos (github.md).
- **Aggressive 2025–2026 OSS distribution offensive:** plugins for Claude Code, Codex, Cursor, Copilot, opencode, Kimi, Grok, Hermes, OpenClaw, xAI marketplace; Crawlee v4 Rust-core rewrite (github.md, A).

### Q5. Public revenue signals

- Private company; no official ARR released beyond 2023's €6.7M/€1M-profit.
- Estimates: GetLatka $13.3M ARR 2024 (B); Prospeo $14.7M revenue (B); Seedtable est $16–38M (B, wide band).
- Revenue/employee ~$86k (Prospeo, B). IT spend ~$9.8M/yr (Crunchbase, B).
- Marketplace size signal: $760k/mo dev payouts (Feb 2026, B) — implies meaningful marketplace GMV but Apify only takes platform-usage + a take on paid actors.

### Q6. Competitive context (brief — full scoring is competitive-analysis's file)

From a web standpoint, the 2026 AI-era landscape splits into two camps (B, multiple comparators):
- **AI-native, API-first:** Firecrawl (markdown/JSON-to-LLM, MCP, AGPL-self-hostable, 500 free credits), Browse AI (no-code), Jina Reader, Crawl4AI (open source), Context.dev (YC S26, flat 1-credit/scrape).
- **Platform/marketplace:** Apify (30k+ actors, hosted infra) and **proxy-infra vendors** Bright Data / Oxylabs / Zyte / ScraperAPI (anti-bot at scale, also shipping MCP).
Positioning: Apify = breadth (thousands of prebuilt tools + marketplace), Firecrawl = clean-fast content for RAG, Bright Data = unblocking protected sites. Many production agents combine all three (use-apify 2026-03-15). Market sizing: web scraping software ~$1.56B 2026 → $3.49B 2031 (Mordor, 17.4% CAGR); AI agents ~$7.84B 2025 → $52.62B 2030 (MarketsandMarkets, 46.3%) (B via toolproven). Apify's own blog runs Firecrawl-vs-Apify head-to-head (blog.apify.com, 2026-09-01). Full competitive scoring lives in competitive.md — not repeated here.

## Market / factual notes (feed for analysis)

1. **Business model is a usage-metered marketplace + PaaS, not a flat SaaS.** Everything (compute, proxies, storage, data transfer, paid actors) draws down a monthly prepaid credit at per-unit rates; overage is billed. This is the moat economics (recurring consumption) and the pain point (unpredictable bills). Source: apify.com/pricing (A).
2. **Residential proxies are the expensive, infra-heavy component** ($8/GB) — replicating a resilient residential proxy network (geo coverage, freshness, anti-fingerprint) is the hardest/least-commoditized part of the stack a competitor would face. Datacenter is cheap-ish ($0.6–1/IP). Infer from list price (C on real cost — Apify doesn't publish infra cost).
3. **Moat = marketplace network effects + hosted runtime + proxy trust**, all closed/proprietary (github.md's open-vs-closed boundary). Brand in the AI-agent ecosystem is now a deliberate moat (MCP server, x402, agent templates, coding-agent plugins).
4. **Rental-actor retirement (Oct 2026)** means the marketplace is consolidating to pay-per-event/usage — a normalize-toward-consumption move that straightens pricing for developers.
5. **Growth funded mostly by profits** (bootstrapped 2019–2024 then a small seed) — a capital-efficient, profitable operator, not a VC-burn machine. Low valuation multiple ($5.5M Caplight est. valuation is clearly stale/low — treat as unreliable, C).
6. **Trust/enterprise:** SOC 2 Type II, GDPR, CCPA, 99.95% uptime (Feb 2026 PR, B); enterprise customers Siemens, Microsoft, Intercom, Groupon, European Commission.

## Unresolved

1. **Real revenue/ARR post-2023:** private; only 2023 primary (€6.7M) + third-party 2024 estimates ($13.3M GetLatka). No 2025/2026 official figure. C.
2. **Real infra cost of the residential proxy network:** only inferred from $8/GB list price. C.
3. **Exact current Actor Store size:** inconsistent across sources (15k Feb-2026 → 20k+ Mar-2026 → 30k+ mid-2026 → 52k+ Jul-2026); definitions vary. Directionally huge growth, exact count C.
4. **Plan price discrepancy:** apify.com now shows Starter $19; multiple reliable third parties report $29 as of mid-2026. Possibly a recent drop or regional pricing. Needs re-verification; competitors must check live. C.
5. **Customer-count figure:** 10k vs 25k vs 40k across sources — only directional. C.
6. **Post-2025 direction is AI-first but no public "revenue from AI" split.** Latest public product news is x402 (Jun 2026) + MCP connectors (Jun 2026). Whether AI-agent tool usage is already material revenue is undisclosed. C.
7. **"strands"** internal AI platform product scope (github.md) — web-unverifiable from public docs here. C.
