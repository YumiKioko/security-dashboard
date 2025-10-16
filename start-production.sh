#!/bin/bash

echo "🚀 Starting Security Dashboard in Production Mode"

# Check if PM2 is installed
if ! command -v pm2 &> /dev/null; then
    echo "Installing PM2..."
    npm install pm2 -g
fi

# Create production directories
mkdir -p logs data

# Install production dependencies
npm install --production

echo "Starting application with PM2..."
pm2 start ecosystem.config.js --env production

echo "✅ Application started in production mode"
echo "📊 View status: pm2 status"
echo "📋 View logs: pm2 logs"
echo "🔄 Restart: pm2 restart security-dashboard"
echo "🛑 Stop: pm2 stop security-dashboard"

# Save PM2 configuration for auto-start on reboot
pm2 save
pm2 startup

echo ""
echo "🎯 Production Dashboard running on: http://localhost:3000"
echo "🔧 Health check: curl http://localhost:3000/api/health"
