#!/bin/bash

case "$1" in
    start)
        ./start-prod.sh
        ;;
    stop)
        pm2 stop security-dashboard
        echo "✅ Dashboard stopped"
        ;;
    restart)
        pm2 restart security-dashboard
        echo "✅ Dashboard restarted"
        ;;
    status)
        echo "📊 Current Status:"
        pm2 status
        ;;
    logs)
        echo "📋 Recent Logs:"
        pm2 logs security-dashboard --lines 20
        ;;
    monitor)
        echo "📈 Production Monitor"
        echo "===================="
        echo "Health: $(curl -s http://localhost:3000/api/health | head -1)"
        echo ""
        echo "PM2 Status:"
        pm2 status
        ;;
    backup)
        ./backup-dashboard.sh
        ;;
    setup-autostart)
        echo "🔧 Setting up auto-start on boot..."
        sudo env PATH=$PATH:/home/user/.nvm/versions/node/v22.20.0/bin /usr/local/lib/node_modules/pm2/bin/pm2 startup systemd -u user --hp /home/user
        echo "✅ Auto-start configured"
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|logs|monitor|backup|setup-autostart}"
        echo ""
        echo "Production Dashboard Manager"
        echo "  start           - Start dashboard"
        echo "  stop            - Stop dashboard"
        echo "  restart         - Restart dashboard"
        echo "  status          - Check status"
        echo "  logs            - View logs"
        echo "  monitor         - Show monitoring info"
        echo "  backup          - Create backup"
        echo "  setup-autostart - Configure auto-start on boot"
        exit 1
        ;;
esac
