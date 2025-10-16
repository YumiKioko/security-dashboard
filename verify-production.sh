#!/bin/bash

echo "🔍 Verifying Production Setup"

# Check if containers are running
echo "1. Checking containers..."
docker-compose -f docker-compose.prod.yml ps

# Test health endpoint
echo ""
echo "2. Testing health endpoint..."
curl -f http://localhost:80/api/health && echo " ✅ Health check PASSED" || echo " ❌ Health check FAILED"

# Test main API endpoints
echo ""
echo "3. Testing API endpoints..."
apis=("/api/security-data" "/api/incidents" "/api/compliance" "/api/infrastructure" "/api/security-ops")

for api in "${apis[@]}"; do
    if curl -s -f "http://localhost:80$api" > /dev/null; then
        echo " ✅ $api - WORKING"
    else
        echo " ❌ $api - FAILED"
    fi
done

# Check logs
echo ""
echo "4. Checking for errors in logs..."
docker-compose -f docker-compose.prod.yml logs --tail=20 | grep -i error || echo " ✅ No errors found in recent logs"

echo ""
echo "🎯 Production Verification Complete"
echo "📊 Dashboard: http://localhost:80"
echo "🔧 API Base: http://localhost:80/api"
