#!/bin/bash
echo "Starting Security Dashboard..."
cd "$(dirname "$0")/.."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Error: Node.js is not installed"
    exit 1
fi

# Start the API server
echo "🔧 Starting API Server on port 3000..."
node server.js &

# Wait a moment for server to start
sleep 2

# Open the dashboard in default browser
echo "🌐 Opening dashboard in browser..."
if command -v xdg-open &> /dev/null; then
    xdg-open http://localhost:3000
elif command -v gnome-open &> /dev/null; then
    gnome-open http://localhost:3000
else
    echo "Please open http://localhost:3000 in your browser"
fi

echo "✅ Dashboard started!"
echo "📊 Access at: http://localhost:3000"
echo "🛑 Press Ctrl+C to stop the server"
