---
name: agentos-ops
description: Set up scheduled /os runs on Linux (systemd), macOS (launchd), or cross-platform (pm2). Use when the user wants to automate AgentOS research runs, schedule recurring /os tasks, or needs a systemd timer / LaunchAgent / pm2 config for AgentOS.
license: MIT
metadata:
  version: "1.0.0"
  author: AgentOS
  source: "https://github.com/NasrullaAmeen/AgentOS"
---

# AgentOS Ops

Schedule recurring `/os <task>` runs on Linux, macOS, or any platform with pm2.

## Templates

| Scheduler | OS | Files |
|---|---|---|
| systemd timer | Linux | `ops/systemd/agent-os.service`, `ops/systemd/agent-os.timer` |
| LaunchAgent | macOS | `ops/launchd/com.agentos.plist` |
| pm2 | cross-platform | `ops/pm2/ecosystem.config.js` |

## Quick start

### systemd (Linux)

```bash
mkdir -p ~/.config/systemd/user
cp ops/systemd/agent-os.service ~/.config/systemd/user/
cp ops/systemd/agent-os.timer ~/.config/systemd/user/
systemctl --user edit agent-os.service   # set AGENTOS_TASK env var
systemctl --user daemon-reload
systemctl --user enable --now agent-os.timer
```

### LaunchAgent (macOS)

```bash
cp ops/launchd/com.agentos.plist ~/Library/LaunchAgents/
# Edit the plist to set a real task + correct paths
launchctl load ~/Library/LaunchAgents/com.agentos.plist
```

### pm2 (cross-platform)

```bash
pm2 start ops/pm2/ecosystem.config.js
# Edit the task in ops/pm2/ecosystem.config.js before starting
```

## Verify

```bash
# systemd
systemctl --user status agent-os.timer
journalctl --user -u agent-os.service -f

# launchd
launchctl list | grep agentos
log show --predicate 'subsystem == "com.agentos.os"' --last 1h

# pm2
pm2 logs agent-os
pm2 monit
```

## Conventions

- **Session-based cron is not enough** — it dies when the session ends.
- **Run the task manually first** (`/os <task>`) to verify the verdict + ECC handoff path works before scheduling.
- **Logs go to**: journalctl (systemd), `~/Library/Logs/` (launchd), or configured out/err files (pm2).
