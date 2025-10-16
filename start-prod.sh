#!/bin/bash

echo "🚀 Starting Security Dashboard (Production Mode)"

# Clean up any existing processes
pm2 stop security-dashboard 2>/dev/null
pm2 delete security-dashboard 2>/dev/null

# Kill any stray Node processes
pkill -f "node.*server-complete" 2>/dev/null
sleep 2

# Ensure port is free
sudo fuser -k 3000/tcp 2>/dev/null
sudo fuser -k 8080/tcp 2>/dev/null

# Create necessary directories
mkdir -p logs data

# Install production dependencies
npm install --production

# Start with PM2
pm2 start ecosystem.config.js

# Save PM2 configuration
pm2 save

echo "✅ Production dashboard started successfully!"
echo "📊 Dashboard: http://localhost:3000"
echo "🔧 Health: curl http://localhost:3000/api/health"
echo ""
echo "Management commands:"
echo "  pm2 status              # Check status"
echo "  pm2 logs security-dashboard --lines 10  # View logs"
echo "  pm2 restart security-dashboard          # Restart"
echo "  pm2 stop security-dashboard             # Stop"
