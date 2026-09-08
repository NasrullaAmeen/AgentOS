# ops/ — scheduled / autonomous AgentOS runs

Ready-to-use scheduler templates for running `/os <task>` on a schedule.

## Templates

| Scheduler | OS | Files |
|---|---|---|
| systemd timer | Linux (systemd) | `systemd/agent-os.service`, `systemd/agent-os.timer` |
| LaunchAgent | macOS | `launchd/com.agentos.plist` |
| pm2 | cross-platform | `pm2/ecosystem.config.js` |

## Quick start

### systemd (Linux)

```bash
# 1. Copy the unit files
mkdir -p ~/.config/systemd/user
cp ops/systemd/agent-os.service ~/.config/systemd/user/
cp ops/systemd/agent-os.timer ~/.config/systemd/user/

# 2. Set the real task
systemctl --user edit agent-os.service
# Add:
#   [Service]
#   Environment="AGENTOS_TASK=Reverse engineer <target>"

# 3. Enable
systemctl --user daemon-reload
systemctl --user enable --now agent-os.timer
```

### LaunchAgent (macOS)

```bash
cp ops/launchd/com.agentos.plist ~/Library/LaunchAgents/
# Edit the plist to set a real task + correct paths for your machine
launchctl load ~/Library/LaunchAgents/com.agentos.plist
```

### pm2 (cross-platform)

```bash
pm2 start ops/pm2/ecosystem.config.js
# Edit the task in ops/pm2/ecosystem.config.js before starting
```

## Notes

- **Session-based cron is not enough** — it dies when the session ends. Use systemd, launchd, or pm2.
- **Run the task manually first** (`/os <task>`) to verify the verdict + ECC handoff path works before scheduling.
- **Logs go to**: journalctl (systemd), `~/Library/Logs/` (launchd), or the configured out/err files (pm2).
