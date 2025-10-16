#!/bin/bash

case "$1" in
    start)
        echo "Starting security dashboard..."
        node server.js &
        echo $! > server.pid
        echo "✅ Server is running (PID: $(cat server.pid))"
        ;;
    dev)
        echo "Starting in development mode..."
        nodemon server.js
        ;;
    test)
        echo "Testing endpoints..."
        curl -f http://localhost:3000/api/health || echo "❌ Server not responding"
        ;;
    stop)
        if [ -f server.pid ]; then
            kill $(cat server.pid)
            rm server.pid
            echo "✅ Server stopped"
        else
            echo "❌ No running server found"
        fi
        ;;
    *)
        echo "Usage: $0 {start|dev|test|stop}"
        exit 1
        ;;
esac
