# Competitor deep-dive

Use this template when the user asks to research a competitor, compare products, or understand a competitive landscape.

## Trigger phrases
- "Research <competitor>"
- "Compare <product A> vs <product B>"
- "What are the alternatives to <product>?"
- "Competitive analysis of <market>"

## Expected output

A `competitive.md` in `memory/ai/research/<slug>/` containing:

1. **Landscape summary** — who plays in this space, market size if relevant
2. **Tier table** — direct competitors, adjacent players, indirect/upstream-downstream
3. **Scoring matrix** — score each competitor 1–5 on:
   - Positioning clarity
   - Feature breadth vs depth
   - Pricing model
   - Developer experience
   - Community/ecosystem
   - Maintenance/activity
4. **White space** — gaps no one is filling well
5. **Sources** — every score tied to a primary source (repo, docs, pricing page)

## Research channels

| Channel | What to look for | Priority |
|---|---|---|
| `github-research` | Stars, forks, commit frequency, issue velocity, release cadence | High |
| `web-research` | Pricing pages, changelogs, blog posts, analyst coverage | High |
| `reddit-research` | r/<product>, r/selfhosted, r/SideProject — pain points, migration threads | Medium |
| `competitive-analysis` | Scoring + white-space synthesis | Final step |

## Tips

- Pin to **specific versions/releases** when comparing features (use GitHub releases).
- Distinguish **marketing claims** from **verified capabilities** (check actual code/docs).
- Include at least one **contrarian source** (e.g., a critical review or migration-away thread).
