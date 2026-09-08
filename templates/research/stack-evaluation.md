# Stack evaluation

Use this template when the user asks to evaluate a technology, library, framework, or tool for adoption.

## Trigger phrases
- "Should we use <library>?"
- "Evaluate <framework> vs <framework>"
- "Is <tool> production-ready?"
- "Research <technology> for our stack"

## Expected output

A `research/<slug>/` folder with:

1. **`web.md`** — official docs, version stability, license, maintainer, release cadence, breaking-change history
2. **`github.md`** — repo health: stars, contributors, issue/PR velocity, security advisories, CI status
3. **`reddit.md`** (optional) — community sentiment, production war stories, common pitfalls
4. **`reverse-engineering.md`** (if source available) — architecture, extensibility points, integration surface
5. **`synthesis.md`** — recommendation with rationale, risk factors, migration cost if replacing an existing tool

## Evaluation criteria

| Criterion | Weight | How to assess |
|---|---|---|
| License compatibility | High | LICENSE file, CLA, Contributor Agreement |
| Maintenance health | High | Release frequency, commit graph, maintainer responsiveness |
| API stability | High | Semver adherence, breaking-change rate, deprecation policy |
| Community adoption | Medium | GitHub stars, Stack Overflow tags, blog references |
| Performance | Medium | Benchmarks (official + independent), bundle size |
| DX / ergonomics | Medium | TypeScript support, error messages, documentation quality |
| Ecosystem | Medium | Plugins, integrations, framework-specific bindings |
| Security | High | Security policy, audit history, CVE count |

## Tips

- Prefer **primary sources** (repo, official docs) over blog posts.
- If the library has a **migration guide from a competitor**, that's a strong signal of comparative intent.
- Flag **bus factor** risk: is the project maintained by one person or an org?
