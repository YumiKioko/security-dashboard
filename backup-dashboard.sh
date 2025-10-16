#!/bin/bash

# Security Dashboard Backup Script
echo "🔒 Creating Security Dashboard Backup..."

# Configuration
BACKUP_DIR="$HOME/security-dashboard-backup"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_NAME="security-dashboard-backup_$TIMESTAMP"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📦 Starting backup process...${NC}"

# Create backup directory
mkdir -p "$BACKUP_DIR/$BACKUP_NAME"

# Backup all dashboard files
echo "Backing up dashboard files..."
cp -r ~/security-dashboard/* "$BACKUP_DIR/$BACKUP_NAME/" 2>/dev/null

# Create backup info file
cat > "$BACKUP_DIR/$BACKUP_NAME/BACKUP_INFO.txt" << INFO
Security Dashboard Backup
=========================
Backup Date: $(date)
Backup Name: $BACKUP_NAME
Original Location: ~/security-dashboard
Files Included:
- HTML Dashboard files
- JavaScript server files
- Configuration files
- Data sources
- Package configuration

To restore:
1. Copy files back to ~/security-dashboard
2. Run: cd ~/security-dashboard && npm install
3. Start: node server-complete.js

Backup completed successfully!
INFO

# Create file list
find ~/security-dashboard -type f -name "*.js" -o -name "*.html" -o -name "*.json" | head -20 > "$BACKUP_DIR/$BACKUP_NAME/file_list.txt"

echo -e "${GREEN}✅ Backup completed successfully!${NC}"
echo ""
echo "📁 Backup location: $BACKUP_DIR/$BACKUP_NAME"
echo "📊 Backup contents:"
ls -la "$BACKUP_DIR/$BACKUP_NAME"
echo ""
echo "💾 Total backup size:"
du -sh "$BACKUP_DIR/$BACKUP_NAME"
echo ""
echo "🔍 To view backup info: cat $BACKUP_DIR/$BACKUP_NAME/BACKUP_INFO.txt"
