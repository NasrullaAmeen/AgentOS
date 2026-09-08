module.exports = {
  apps: [
    {
      name: 'agent-os',
      script: '/usr/local/bin/opencode',
      args: '--command "/os <task>"',
      cwd: '/home/darko/Projects',
      env: {
        OPENCODE_CONFIG_DIR: '/home/darko/.config/orca/opencode-hooks/shared',
      },
      autorestart: false,
      max_restarts: 0,
      // Run once per day via cron
      cron_restart: '0 6 * * *',
      out_file: '/tmp/agent-os.out.log',
      error_file: '/tmp/agent-os.err.log',
      log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
    },
  ],
}
