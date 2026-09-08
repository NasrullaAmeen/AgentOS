# Reddit Research — Apify (sentiment / community evidence)

Slug: `apify` · Date: 2026-09-08 · Agent: reddit-research (big-pickle) · Channel: rdt-cli v0.4.2 (working, re-run)

> This file REPLACES the earlier "channel unavailable" stub. First collection run successful.
> Raw search JSON archived under `/home/darko/.local/share/opencode/tool-output/tool_*.l`.

## Summary

- **Overall sentiment: mixed, with pricing friction as the dominant negative theme** — heavy-use users repeatedly report "costs add up fast," free-plan credits burn quickly, and builder/developer revenue share is called unfair; several threads feature users building their *own* alternatives (GetXAPI, crawlyx, Figranium) after hitting Apify/Firecrawl bills.
- **The strongest positive signal is the AI-agent wedge**: "Apify MCP is scary" (r/mcp, 235 pts) is genuine user awe at autonomous LinkedIn research via MCP, with pay-per-use costs reported as cents — this validates the AI-agent-native opportunity.
- **Apify is positioned in the middle of the market**: commenters contrast it with Bright Data/Oxylabs (bigger proxy pools, more enterprise) *and* with Firecrawl/crawl4ai (cheaper, OSS, self-host), while n8n users treat Apify as the default "actor store" but resent per-actor pricing opacity and reseller margins.
- **Repeated sub-themes**: per-run setup fees wreck small-run unit economics (r/apify insider post), actor-card price visibility is poor (third-party Chrome extension exists to fix it), free plan "$5 consumed very quickly," and the marketplace is criticized as economically unsustainable *for third-party builders* (first-party actors dominate top categories).
- Internal r/apify sentiment is comparatively favorable to the product itself (store data analysis, client-library love, pricing pedagogy) — the complaints come from the edges: marketplace builders, light users, and cost-sensitive n8n/indie users.

## Claims

1. **Heavy-use cost escalation is the #1 community complaint and the top churn driver.**
   - "I've been a big fan of Apify actors and other Twitter API alternatives, but once you start using them heavily the costs add up fast." — OP built GetXAPI as a cheaper replacement (claims $0.001/request, ~$0.05/1k tweets vs claimed Apify $0.25/1k tweets), received 223 pts / 76 comments.
   - Source: https://www.reddit.com/r/developersIndia/comments/1qzwkjn/twitters_api_is_expensive_and_im_done_with_apify/ — r/developersIndia, 2026-02-09, **A** (high score, multi-thread pattern).
   - Corroborated: "Apify's free plan consumes 5$ very quickly" — r/n8n, https://www.reddit.com/r/n8n/comments/1v783nr/is_there_any_alternative_to_apify_for_reddit/ , 2026-07-26, **A**.

2. **Users churning off Apify often do NOT leave the problem — they build a competing product.** The "done with Apify/RapidAPI" thread crossposted to r/n8n and r/SideProject with the same build-your-own framing; price-comparison wars break out in the comments (one commenter calls OP's $1000 pricing a lie vs twttrapi's $59; another defends Apify's long-running-job reliability).
   - Source: https://www.reddit.com/r/n8n/comments/1r2reim/twitters_api_is_expensive_and_im_done_with_apify/ — r/n8n, 2026-02-11, **B** (crosspost, lower score, but real ecosystem evidence).
   - Related build-your-own-after-bill-shock: "Built a Rust web crawler after getting fed up with Firecrawl's pricing and crawl4ai's RAM usage" (replaces Firecrawl/Crawl4ai; benchmarks Crawlee at 110s vs his 53s on 200 pages; "Crawlee was decent but the output format wasn't what I needed downstream") — r/SideProject, https://www.reddit.com/r/SideProject/comments/1uc1gfo/built_a_rust_web_crawler_after_getting_fed_up/ , 2026-06-21, **C** (self-promo, low score, but detailed real claims incl. Firecrawl self-host = Postgres+Redis+RabbitMQ+workers+Playwright).

3. **Per-run pricing model punishes small/automated runs — insiders themselves teach batching as the mitigation.**
   - "Your Apify cost per 1,000 results is mostly a run-size problem, not a per-result price problem": ~$0.02/run setup event dominates; 100 pages as 100 separate runs ≈ $2.99 vs ~$1.01 batched; n8n "Split In Batches" workflows are the most expensive shape.
   - Source: https://www.reddit.com/r/apify/comments/1w6ahko — r/apify, 2026-09-03, **B** (low score but insider-technical, no replies; corroborates `web.md` pricing-complexity thesis).
   - Related: commenter on "Pay per use Apify Alternatives?" clarifies pricing is per-actor (pay-per-result actors exist) with free-plan platform credit — https://www.reddit.com/r/apify/comments/1vpqdv8/pay_per_use_apify_alternatives/ — r/apify, 2026-08-16, **B** (modest score; shows even Apify users don't understand the pricing model).

4. **Third-party marketplace builders feel the platform is economically stacked against them.**
   - "I don't see how I can continue to build on the platform … from a developer marketplace perspective I'm struggling to see how it's economically sustainable." — developer revenue small relative to usage; top categories dominated by first-party (Apify-owned) actors; switch to monthly-rental actors.
   - Source: https://www.reddit.com/r/apify/comments/1rpswcb/apify_your_pricing_changes_for_builders_is_unfair — r/apify, 2026-03-10, **B** (low score but insider, marketplace-specific).
   - Corroborated by supply/demand analysis of 54,025 public actors (715,034 summed 30-day users; Social Media demand 1.48× supply ratio): https://www.reddit.com/r/apify/comments/1v5ltmz — r/apify, 2026-07-24, **B**.

5. **The AI-agent wedge ("Apify Agent"/MCP) generates the strongest positive buzz any Apify product has on Reddit.**
   - "It's ridiculous… Seeing Claude just fully autonomous, calling LinkedIn, investigating companies, people, building profiles … it takes about 3 seconds to just paste the MCP config." — 235 pts / 84 comments; OP reports "0.23$ for me… pay per use, generally these are cents per thousands results." Skepticism exists ("Sounds like an ad") but OP is a 12-year non-Apify redditor.
   - Source: https://www.reddit.com/r/mcp/comments/1lsohti/apify_mcp_is_scary/ — r/mcp, 2025-07-06, **A** (high score, long thread).
   - Counter-signal: at least one commenter saw "$39/month" instead of the pay-per-use tier and asked what they were missing — pricing-model confusion extends even to the MCP product.

6. **Apify is considered a good "middle" choice for JS-render/rotator problems, but proxy-heavy enterprise users default to Bright Data/Oxylabs.**
   - "Proxy pool size is the wrong first filter here. For public market pages the breakage is usually JS render plus Cloudflare/DataDome… Apify or ScrapingBee can be saner for JS rendering and proxy rotation than wiring Bright Data into your own Playwright fleet." (2 pts) — plus a warning that Bright Data demands ID upload to pay (usability friction for the competitor).
   - Source: https://www.reddit.com/r/Stocks_Picks/comments/1cwqnlm/brightdata_vs_oxylabs_vs_apify_for_scraping_large/ — r/Stocks_Picks, 2024-05-20 (older but on-topic), **B**.
   - Startup framing (r/it): heavy-scale operator (hundreds of millions of pages/day) recommends DIY Scrapy + ChatGPT over reseller APIs "for a lot less money," noting API data is often not real-time — https://www.reddit.com/r/it/comments/1dcvrx9/thoughts_on_what_are_the_best_web_scraping_tools/ — r/it, 2024-06-10, **B**.

7. **Self-hosted / OSS alternatives to Apify are actively pitched in its own subreddit** — Figranium ("open-source Apify alternative", stealth/anti-detection, CAPTCHA handling, ~500 GitHub stars) posted in r/apify; store comparison threads surface Crawlee as the OSS route.
   - Source: https://www.reddit.com/r/apify/comments/1vvjg0h/figranium_an_open_source_apify_alternative/ — r/apify, 2026-08-22, **C** (promotional, low engagement).
   - Crawlee reception itself is warm: "Crawlee for Python v1.0 is LIVE!" scored 74 in r/Python (Apify staff AMA, mostly positive/banter) — https://www.reddit.com/r/Python/comments/1nu8tt6/crawlee_for_python_v10_is_live/ , 2025-09-30, **B**.

8. **Price/usage visibility on the Actor Store is poor enough that third parties monetize the fix.**
   - "Price is missing from actor cards… clicking into each actor to see cost adds up; 10 actors = 10 extra clicks." — OP ships a Chrome extension ("Apify Stats by ParseBird") showing pricing, MAU, and last-update directly on cards.
   - Source: https://www.reddit.com/r/apify/comments/1sk89al — r/apify, 2026-04-13, **C** (low score, but product-market evidence of a UX gap).

9. **Firecrawl-vs-Crawl4ai comparisons (proxy for the wider API-vs-OSS debate) favor OSS on cost, paid APIs on convenience.**
   - Crawl4ai: OSS, free, 58k stars, runs locally, but 4GB RAM and full self-host ops burden. Firecrawl: 100k stars, YC-backed, ~96% coverage, 1 credit/page, $16/mo starter, 500 free credits; credits felt annoying.
   - Source: https://www.reddit.com/r/AgentsOfAI/comments/1t3pe4e/firecrawl_vs_crawl4ai_i_tried_both_and_heres/ — r/AgentsOfAI, 2026-05-04, **B** (52 pts / 29 comments).

## Sentiment

- **Overall: MIXED-NEGATIVE on pricing/ecosystem, POSITIVE on the AI-agent product and on the actor-store concept.** The most-shared emotional driver is bill shock among heavy and light users alike ("costs add up fast"; "$5 free plan consumed very quickly"; "$29/m is unnecessary" for once-every-6-months use).
- **Positive examples:** *"Yep rm -r is glorious ask about it"* (top joke thread, r/mcp); *"Apify in particular shines with long-running jobs, persistence, and reliability at scale"* (r/n8n); *"Save Apify for other social platforms"* (r/n8n, i.e. keep Apify for hard targets, use Reddit's own API/JSON for Reddit); crawlee-python v1.0 launch warmly received in r/Python.
- **Negative examples:** *"an apify guy who is reselling and earning easy money from people that do not know the official reddit api can do the same"* (r/n8n); *"your pricing changes for builders is unfair"* (r/apify); *"I'm done with Apify and RapidAPI—so I built my own"* (r/developersIndia, 223 pts — the loudest thread of the set).
- **Caution:** the loudest negative thread (1qzwkjn) is partially promotional (OP launched a competing service) and comments push back on his price claims; treat the *direction* (cost pain is real) as strong, the *specific numbers* as contested.

## Contrarian views

- **Apify's reliability/scale is the credible defense:** r/n8n commenter argues Apify shines on long-running jobs, persistence, and reliability at scale, asking challengers to state their performance/cost-model tradeoffs — "Man speaks in corpo babble 😂" (downvoted-ish reply) suggests not all agree, but the reliability claim itself went unchallenged.
- **Official-API-first camp (mild anti-reseller sentiment):** multiple r/n8n commenters steer users to Reddit's own JSON endpoints / paid API plans as cheaper than any reseller actor — if this generalizes, thin wrapper "reseller" actors are the most exposed part of the store.
- **Perf trade-off defense:** a Firecrawl staffer responded to the crawlyx benchmark saying speed is a deliberate trade (full browser rendering + clean LLM-ready Markdown vs raw HTTP), i.e. the paid-API cost is buying rendering/anti-bot/formatting, not raw speed.
- **"Sounds like an ad"** skepticism greets highly positive Apify MCP/Agent posts; OP identity matters for credibility in this community.

## Unresolved

1. **"Apify billing surprise" search returned no results** — the specific "surprise bill/invoice shock" genre is not visible via Reddit search; do not claim it exists on the basis of absence (code succeeded, no data). Weird-billing complaints may live in r/n8n workflow threads and r/apify comments rather than title matches.
2. Older-than-2024 pricing threads not paginated (`--after t3_1m8778g` etc. backlog) — the 2024 r/Stocks_Picks and r/it comparisons came up opportunistically; a fuller historical sweep could confirm whether cost complaints predate the 2025-26 pricing changes.
3. r/scrapingtheweb "$1000 for someone who really knows their web-scraping stuff" (128 pts / 117 cmts) identified but **not read** — may contain hiring-side sentiment on tooling stacks.
4. r/n8n "Apify" workflow threads (the largest integration surface) not individually mined for billing-confusion anecdotes beyond the two threads above; n8n is likely the highest-volume complaint venue.
5. The `r/SideProject` crosspost (1r0xm91) and `1nz1lq6` not read — same-title crossposts mostly duplicate the developersIndia thread.