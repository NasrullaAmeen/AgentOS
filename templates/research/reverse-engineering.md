# Reverse engineering

Use this template when the user asks to understand how an unknown system works — from source code, binaries, or observed behavior.

## Trigger phrases
- "Reverse engineer <system>"
- "How does <protocol/api> work?"
- "Map the internals of <tool>"
- "What are the entry points in <codebase>?"

## Expected output

A `reverse-engineering.md` in `memory/ai/research/<slug>/` containing:

1. **Summary** — 3–5 sentence bottom line: what the system is, how it's structured, what the user should know
2. **Architecture map** — top-level modules, dependencies, data flow (use archify if helpful)
3. **Entry points** — where a caller first touches the system (CLI commands, API endpoints, message queues, exported functions)
4. **Key flows** — the 2–3 most important paths through the system (file:line references)
5. **External surface** — network calls, file I/O, environment variables, config files
6. **Open questions** — what couldn't be determined from available evidence

## Research channels

| Channel | What to look for | Priority |
|---|---|---|
| `github-research` | README, architecture docs, commit messages, release notes | High |
| `web-research` | Blog posts, conference talks, RFCs, design docs | Medium |
| `reverse-engineering` | Source code walkthrough, dependency graph, entry-point mapping | Core |

## Tips

- **Descriptive only** — no modification, hacks, or monetization advice.
- Cite **file:line** for every claim about code behavior.
- If the system is a **protocol**, include a sequence diagram of a typical session.
- Flag anything that looks like **undocumented behavior** vs clearly documented features.
