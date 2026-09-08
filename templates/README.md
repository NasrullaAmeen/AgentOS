# templates/ — reusable research templates

Ready-to-use templates for common `/os` research tasks. Agents read the matching template at run start to calibrate scope, output format, and source priority.

## Index

| Template | Trigger | Primary channels | Output |
|---|---|---|---|
| `research/competitor-deep-dive.md` | "Research <competitor>", "Compare X vs Y" | github, web, reddit | `competitive.md` |
| `research/stack-evaluation.md` | "Should we use X?", "Evaluate X vs Y" | github, web, reverse-engineering | `web.md`, `github.md`, `synthesis.md` |
| `research/vulnerability-scope.md` | "Security review", "Audit for vulnerabilities" | github, web | `synthesis.md` + risk rating |
| `research/reverse-engineering.md` | "Reverse engineer X", "How does X work?" | github, web, reverse-engineering | `reverse-engineering.md` |

## How to use

1. Match the user's request to a template by trigger phrases.
2. Read the full template before dispatching agents.
3. Use the template's **evaluation criteria** as a checklist when scoring or recommending.
4. Follow the **output structure** exactly so downstream consumers (`analysis`, ECC) can rely on consistent format.

## Adding a new template

Create `templates/research/<name>.md` with:

- `# <Name>` — title
- `## Trigger phrases` — exact phrases that match this template
- `## Expected output` — file(s) produced, section headers, structure
- `## Research channels` — table of which agents to dispatch, in what order
- `## Tips` — 3–5 domain-specific heuristics
