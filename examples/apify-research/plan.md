# Research Plan — Apify: Reverse Engineering + "Can We Compete?"

Slug: `apify`
Date: 2026-09-08
Type: M2 pilot (deep, decision-grade, full-stack)

## Assumptions (state before research)

- **"We"** = a solo developer / small team on this machine (`/home/darko/Projects`) building AI-agent
  tooling, evaluating whether to build a product that competes with Apify (web scraping + browser
  automation + AI-agent data access platform). No prior company context found in memory vaults.
- **Scope**: full-stack — product surface, business model, open-source codebase, platform
  internals, community sentiment, competitive landscape. "Can we compete" requires all four.
- **Depth**: deep. This is a go/no-go input, not a quick scan.
- **Audience**: decision-maker with engineering background (needs both verdict and technical receipts).
- **Competition posture to test**: we are a small player; therefore "compete" realistically means a
  niche attack (AI-agent-native API, self-hosted/open-core, vertical focus, price simplicity) — not
  a head-on rebuild of the full Apify cloud. The research must surface where that opening is.

## Bottom line up front (to be updated by analysis after agents run)

Nothing known yet — pilot. Post-run, `synthesis.md` must answer: What is Apify, what is its moat,
and where is the smallest credible wedge a solo/small team could enter?

---

## Research Questions

| # | Question | Channel | Why this channel / what evidence answers it |
|---|----------|---------|---------------------------------------------|
| RQ1 | What is Apify as a business? Business model, product surface (Actors, Crawlee, Store, proxies, Apify Agent), pricing model, funding, revenue signals, headcount, 2024–2026 news (pivot to AI agents, acquisitions, price changes). | web-research | Market/factual claims need current primary sources: apify.com pricing page, TechCrunch/Crunchbase funding, press releases, LinkedIn-ish headcount reports, news. Evidence = URLs + dates + numbers. |
| RQ2 | What is Apify's open-source surface and what can we legally build on? Repos under `apify/*` (crawlee, crawlee-python, apify-sdk-python, apify-js, apify-client-*, actor templates), licenses (Crawlee JS was source-available → Apache-2.0?), activity, release cadence, maturity, ecosystem dependents (LangChain/LlamaIndex/CrewAI/n8n integrations). | github-research | Codebase/tooling/ecosystem questions route here. Evidence = repo URLs, LICENSE files, star counts, commit/issue activity, release tags, dependents. |
| RQ3 | How does the Apify platform actually work internally: Actor execution lifecycle (build → container run → input → storage), request-queue scheduling, KV/dataset storage, compute-unit metering, proxy integration (residential/datacenter groups), CLI/SDK flow? What is proprietary vs re-implementable? | reverse-engineering | Target is a product/codebase; public docs + open-source code (actor templates, Docker images `apify/actor-node`, SDK) let us reconstruct the runtime contract without inside access. Evidence = specific files/repos/Docker images/docs pages per claim. |
| RQ4 | What is Apify's moat? Marketplace network effects (3k+ actors), proxy infrastructure, trust/enterprise, brand in the AI-agent ecosystem (Apify Agent, MCP/LLM integrations), switching costs. | web-research (primary) + competitive-analysis (corroborate) | Factual moat claims come from docs/blog/press; corroborated by competitor positioning. |
| RQ5 | What does the community actually say: pricing complaints, Actor quality variance, support, "Apify vs Firecrawl", self-hosting Crawlee, migration stories, what users love/hate? | reddit-research | Sentiment/adoption/pain-point questions route here. Evidence = threads with URLs + dates + quoted sentiment clusters. |
| RQ6 | Who competes with Apify and how are they positioned: direct (Bright Data, Oxylabs, Zyte, ScraperAPI) and AI-era (Firecrawl, Browserbase, Steel.dev, Browserless, Scrapy Cloud)? Pricing, open-source posture, AI-agent integration depth. | competitive-analysis | "Compare X vs Y" / positioning routes here. Evidence = scored competitor cards with sources. |
| RQ7 | Where is the white space a small player can attack? AI-agent-native DX, self-hosted open-core, niche verticals, pricing simplicity, trust/transparency optics (Apify's complexity is a complaint), marketplace quality. | competitive-analysis + synthesis (analysis agent) | Synthesis lives in `synthesis.md`; competitive-analysis provides the material. |

## Why these channels (summary)

- **github-research** — answers "what exists we could build on / fork / be crushed by." Hard repo facts, licenses, activity.
- **reddit-research** — answers "do users have an open wound we can treat." Unfiltered pain points and migration anecdotes that press releases hide.
- **web-research** — answers "what is the business actually worth fighting." Pricing, funding, pivot news — the moat economics.
- **reverse-engineering** — answers "what would we have to build to replicate the core loop." Runtime contract from docs + open code; separates proprietary (storage/billing/proxy network) from open (SDK/Crawlee).
- **competitive-analysis** — answers "who else is fighting and where the gaps are." Scored competitor set feeding the white-space question.
- **analysis** (post-dispatch, by orchestrator) — merges into `synthesis.md`: verdict + recommendation on wedge.

## Per-agent assignment & output contract

All agents: write to `~/.agents/os/memory/ai/research/apify/<file>`; conclusion-first; every claim
carries a source (URL/repo/file/thread) + A/B/C confidence. Never overwrite other agents' files.
Read `plan.md` before starting. Batch-2 agents should first read batch-1 outputs.

### Batch 1 (parallel — independent evidence streams)

1. **github-research** → `github.md`
   - Required sections: (a) Repo inventory table under `apify/*` org — name, stars, license, last release, primary language; (b) Matching repos: `crawlee`, `crawlee-python`, `apify-sdk-python`, `apify-js`, `apify-client-js/python`, `actor-templates`, `first-solvers`; (c) License analysis — which components are Apache-2.0 / source-available / proprietary; (d) Activity — commit frequency, open issues, PR merge rate, release cadence 2025–2026; (e) Ecosystem — dependents, official integrations (LangChain, LlamaIndex, CrewAI, n8n, Make, Zapier), MCP availability; (f) Top-line: what a competitor could legally fork/self-host today.

2. **web-research** → `web.md`
   - Required sections: (a) Business snapshot — founded, founders, HQ, funding rounds with dates/amounts/investors, latest valuation signal, headcount; (b) Pricing model — free tier, Compute Units, storage, proxy add-ons (residential/datacenter per-GB), enterprise; (c) Product surface today — Actors, Actor Store size (~# actors), Crawlee, Apify Agent / AI-agent products, MCP server, integrations; (d) 2024–2026 trajectory — AI pivot evidence, acquisitions, layoffs, price changes, notable customers; (e) Public revenue signals (if any) — Crunchbase/TechCrunch/Intercom case studies; (f) Source log with dates.

3. **reddit-research** → `reddit.md`
   - Required sections: (a) Sentiment clusters — pricing complaints, actor quality variance, support/sales friction, self-hosting Crawlee, migration away/to; (b) "Apify vs X" threads (Firecrawl, Bright Data, Zyte, self-hosted Scrapy) — what criteria users actually use; (c) AI-agent context — users using Apify Agent / MCP with LLMs, pain points in that flow; (d) Each cluster: 2–3 quoted thread examples w/ URL + date + polarity; (e) Topline: single biggest unmet need voiced.

### Batch 2 (parallel — build on batch 1)

4. **reverse-engineering** → `reverse-engineering.md`
   - Inputs: read `github.md` first. Reconstruct from public docs (docs.apify.com, docs.crawlee.dev) + open source (crawlee, apify-js, apify-sdk-python, actor Dockerfiles `apify/actor-node`).
   - Required sections: (a) Actor runtime contract — input schema → container boot → execution → output; environment variables, memory/CPU tiers, compute-unit metering definition; (b) Storage abstractions — KV store, dataset, request queue: interfaces, semantics, what backend is proprietary; (c) Proxy system — how Actor proxy groups/rotating proxies are configured, residential vs datacenter, what infra would be needed to replicate (inferred, marked C confidence where inferred); (d) CLI/SDK developer loop — apify CLI, push/build/run flow; (e) Proprietary vs open boundary — explicit list: open (re-implementable) vs proprietary (must build ourselves); (f) Effort estimate — rough person-weeks to self-host an Apify-like runtime core using open components (assumption-labeled).
   - Confidence: code/docs = A–B; infrastructure inference = B–C.

5. **competitive-analysis** → `competitive.md`
   - Inputs: read `web.md` first. Required sections: (a) Competitor set by tier (direct: Bright Data, Oxylabs, Zyte, ScraperAPI; AI-era: Firecrawl, Browserbase, Steel.dev, Browserless; open-source: Scrapy ecosystem, self-hosted Crawlee); (b) Score grid — dimensions: scraping infra, proxy coverage, AI-agent integration, marketplace, open-source posture, pricing transparency, developer DX (1–5 rubric, source per score); (c) Positioning vs Apify per competitor; (d) White-space map — dimensions where Apify and all competitors are weak; (e) Topline: smallest credible wedge for a solo/small team.

### Post-dispatch (not mine to run)

6. **analysis** → `synthesis.md` — merges all five, re-answers RQ1–RQ7, verdict on compete/don't-compete + recommended wedge.

## Parallel dispatch batches

- **Batch 1**: github-research, web-research, reddit-research — independent facts, no inter-dependencies.
- **Batch 2**: reverse-engineering (reads github.md), competitive-analysis (reads web.md) — consume batch-1 outputs to avoid re-fetching.
- **Batch 3**: analysis (orchestrator-initiated after 1+2 complete).

## Triage order (drop if time short)

1. **Keep first**: web-research (business model + moat — the crux of "can we compete").
2. **Keep second**: github-research (legal/buildable surface — feasibility floor).
3. **Keep third**: reddit-research (pain points — where the wedge is).
4. **Drop first**: reverse-engineering deep internals — public docs + Crawlee source in github.md cover ~80%; keep only the proprietary-vs-open boundary list.
5. **Drop second**: competitive-analysis full score grid — can be compressed to a competitor table inside synthesis.md.
6. **Drop last**: nothing (pilot quality bar).

## Key unknowns (pre-research)

1. Apify's actual revenue/ARR — private company; may only get funding + headcount proxies. (web)
2. Real infrastructure cost of operating residential/datacenter proxies at scale — we can only infer from pricing. (RE/web)
3. Post-2025 direction of Apify's AI-agent pivot — needs current news, may be thin. (web)
4. What "we" ultimately want to ship — assumption made (AI-agent tooling w/ scraping capabilities); impacts wedge recommendation. (analysis)
5. Whether Firecrawl's recent growth has already occupied the "AI-native scraping API" niche — needs current evidence. (competitive/reddit)

## File layout after run

```
~/.agents/os/memory/ai/research/apify/
├── plan.md               ← this file
├── github.md             ← github-research
├── web.md                ← web-research
├── reddit.md             ← reddit-research
├── reverse-engineering.md← reverse-engineering
├── competitive.md        ← competitive-analysis
├── synthesis.md          ← analysis (post-dispatch)
└── gaps                  ← appended to this plan by planner after analysts run
```