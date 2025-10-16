#!/bin/bash

case "$1" in
    start)
        ./start-production.sh
        ;;
    stop)
        pm2 stop security-dashboard
        echo "✅ Application stopped"
        ;;
    restart)
        pm2 restart security-dashboard
        echo "✅ Application restarted"
        ;;
    status)
        pm2 status
        ;;
    logs)
        pm2 logs security-dashboard
        ;;
    monitor)
        echo "📈 Production Monitoring:"
        echo "Health: curl http://localhost:3000/api/health"
        echo "Status: pm2 status"
        echo "Logs: pm2 logs security-dashboard --lines 20"
        ;;
    backup)
        ./backup-dashboard.sh
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|logs|monitor|backup}"
        echo ""
        echo "Production Management Commands:"
        echo "  start   - Start production server"
        echo "  stop    - Stop production server"
        echo "  restart - Restart production server"
        echo "  status  - Check application status"
        echo "  logs    - View application logs"
        echo "  monitor - Show monitoring information"
        echo "  backup  - Create backup"
        exit 1
        ;;
esac
