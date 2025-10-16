#!/bin/bash
# Script to update threat intelligence feeds
echo "Updating threat intelligence feeds..."

cd "$(dirname "$0")/.."
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Update the main data file with new timestamps
jq --arg ts "$TIMESTAMP" \
   '.threatIntelligence.feeds[].lastUpdate = $ts | 
    .systemHealth.lastUpdate = $ts' \
   data/security-data.json > data/security-data.json.tmp

mv data/security-data.json.tmp data/security-data.json

echo "Feeds updated at $TIMESTAMP"
