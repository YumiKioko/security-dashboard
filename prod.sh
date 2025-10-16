#!/bin/bash

set -e

echo "🚀 Security Dashboard Production Manager"

case "$1" in
    start)
        echo "Starting production stack..."
        docker-compose -f docker-compose.prod.yml up -d
        echo "✅ Production stack started"
        echo "📊 Dashboard: http://localhost:80"
        echo "🔧 API: http://localhost:80/api/health"
        ;;
    stop)
        echo "Stopping production stack..."
        docker-compose -f docker-compose.prod.yml down
        ;;
    restart)
        echo "Restarting production stack..."
        docker-compose -f docker-compose.prod.yml restart
        ;;
    logs)
        docker-compose -f docker-compose.prod.yml logs -f
        ;;
    update)
        echo "Updating production stack..."
        docker-compose -f docker-compose.prod.yml pull
        docker-compose -f docker-compose.prod.yml up -d --build
        ;;
    status)
        echo "Production stack status:"
        docker-compose -f docker-compose.prod.yml ps
        ;;
    backup)
        echo "Creating production backup..."
        ./backup-dashboard.sh
        ;;
    monitor)
        echo "📈 Monitoring production services:"
        echo "Dashboard Health: curl http://localhost:80/api/health"
        echo "Container Status: docker-compose -f docker-compose.prod.yml ps"
        echo "Recent Logs: docker-compose -f docker-compose.prod.yml logs --tail=50"
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|logs|update|status|backup|monitor}"
        echo ""
        echo "Commands:"
        echo "  start   - Start production stack"
        echo "  stop    - Stop production stack"  
        echo "  restart - Restart production stack"
        echo "  logs    - View logs (follow mode)"
        echo "  update  - Update and rebuild stack"
        echo "  status  - Check container status"
        echo "  backup  - Create backup"
        echo "  monitor - Show monitoring info"
        exit 1
        ;;
esac
