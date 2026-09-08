# Instincts — lightweight learning for AgentOS

An instinct is a small learned behavior: one trigger, one action, backed by evidence, with a confidence score.

AgentOS uses plain-file instincts instead of ECC's `ecc-universal` runtime. When ECC's hook infrastructure is available, migrate to `continuous-learning-v2` — see [Migration](#migration-to-ecc-continuous-learning-v2).

## Storage

```
~/.agents/os/memory/ai/instincts/
├── global/                    # Universal patterns (apply everywhere)
│   ├── prefer-functional-style.md
│   └── validate-input-before-query.md
└── project/                   # AgentOS-specific patterns
    ├── use-agent-reach-for-reddit.md
    └── prefer-archify-for-diagrams.md
```

## Instinct format

```markdown
---
id: prefer-archify-for-diagrams
trigger: "when the user asks to visualize architecture, workflow, or data flow"
confidence: 0.8
domain: "tooling"
scope: project
created: 2026-09-08
last_observed: 2026-09-08
---

# Prefer Archify for Diagrams

## Action
Use `archify render` instead of Mermaid for architecture, workflow, sequence, dataflow, and lifecycle diagrams.

## Evidence
- User asked for "mermaid diagrams and tables" in docs (2026-09-08)
- Archify produces interactive HTML with dark/light themes, PNG/SVG/WebM export
- Mermaid is fine for simple flows but Archify handles complex diagrams better

## Counter-evidence
- Mermaid is more portable (GitHub-native, no build step)
- For simple diagrams, Mermaid is faster

## Promotion criteria
- Observed in 2+ projects → promote to global
- Confidence > 0.9 → consider evolving into a skill
```

## Confidence levels

| Score | Meaning |
|---|---|
| 0.3–0.5 | Tentative — one observation, may be context-specific |
| 0.6–0.7 | Likely — 2–3 observations, consistent pattern |
| 0.8–0.9 | Strong — multiple sessions, no counter-evidence |
| 1.0 | Certain — promoted to skill/command/agent |

## Lifecycle

1. **Observe** — during a session, notice a pattern (user correction, repeated choice, tool preference).
2. **Capture** — write an instinct file in the appropriate scope (global or project).
3. **Review** — at session end, check for counter-evidence and update confidence.
4. **Promote** — if confidence > 0.8 and observed in 2+ projects, move to global.
5. **Evolve** — if the instinct is stable (confidence > 0.9 for 5+ sessions), consider turning it into a skill.

## Capture helper

```bash
./ops/instincts/capture.sh "prefer-archify-for-diagrams" "when the user asks to visualize architecture" "tooling" project
```

## Migration to ECC continuous-learning-v2

When `ecc-universal` is installed and hooks are configured:

1. Export AgentOS instincts to ECC format:
   ```bash
   ./ops/instincts/export-to-ecc.sh
   ```
2. Enable ECC hooks for session observation.
3. Disable the plain-file capture helper.
4. ECC takes over observation, clustering, and promotion.

Until then, use the plain-file system above.
