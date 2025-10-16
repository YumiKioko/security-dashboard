module.exports = {
  apps: [{
    name: 'security-dashboard',
    script: 'server-complete.js',
    instances: 1,  // Single instance to avoid port conflicts
    exec_mode: 'fork',  // Fork mode instead of cluster
    env: {
      NODE_ENV: 'production',
      PORT: 3000,
      WS_PORT: 8080,
      LOG_LEVEL: 'info'
    },
    error_file: './logs/pm2-error.log',
    out_file: './logs/pm2-out.log',
    log_file: './logs/pm2-combined.log',
    time: true,
    max_memory_restart: '500M',
    watch: false,
    ignore_watch: ['node_modules', 'logs', 'data']
  }]
};
