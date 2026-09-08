---
name: agentos-research-templates
description: Reusable research templates for common /os tasks in AgentOS. Use when the user asks to research a competitor, evaluate a tech stack, audit security, or reverse-engineer a system — read the matching template before dispatching agents.
license: MIT
metadata:
  version: "1.0.0"
  author: AgentOS
  source: "https://github.com/NasrullaAmeen/AgentOS"
---

# AgentOS Research Templates

Read the matching template before dispatching `/os` research agents. Templates calibrate scope, output format, source priority, and evaluation criteria.

## Templates

| Template | Trigger | Primary channels | Output file |
|---|---|---|---|
| `templates/research/competitor-deep-dive.md` | "Research <competitor>", "Compare X vs Y" | github, web, reddit | `competitive.md` |
| `templates/research/stack-evaluation.md` | "Should we use X?", "Evaluate X vs Y" | github, web, reverse-engineering | `web.md`, `github.md`, `synthesis.md` |
| `templates/research/vulnerability-scope.md` | "Security review", "Audit for vulnerabilities" | github, web | `synthesis.md` + risk rating |
| `templates/research/reverse-engineering.md` | "Reverse engineer X", "How does X work?" | github, web, reverse-engineering | `reverse-engineering.md` |

## How to use

1. Match the user's request to a template by trigger phrases.
2. Read the full template before dispatching agents.
3. Use the template's **evaluation criteria** as a checklist when scoring or recommending.
4. Follow the **output structure** exactly so downstream consumers (`analysis`, ECC) can rely on consistent format.

## Conventions

- Every claim carries a source (URL, file:line, thread link) and **A/B/C confidence**.
- **Conclusion-first** — open with a ≤5-line summary.
- **Append, don't overwrite** — write to `~/.agents/os/memory/ai/research/<slug>/`.
- **No secrets** — never log keys, tokens, or credentials.
