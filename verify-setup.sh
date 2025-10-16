#!/bin/bash

echo "🔍 Verifying Security Dashboard Setup..."

echo "1. Checking Git repository:"
cd ~/security-dashboard
git status
echo ""

echo "2. Latest commit:"
git log --oneline -1
echo ""

echo "3. Number of tracked files:"
git ls-files | wc -l
echo ""

echo "4. Server status:"
if pgrep -f "node server-complete.js" > /dev/null; then
    echo "✅ Server is running"
else
    echo "⚠️  Server is not running"
    echo "   Start with: node server-complete.js"
fi
echo ""

echo "5. Backup status:"
if [ -d "$HOME/security-dashboard-backup" ]; then
    LATEST_BACKUP=$(ls -td "$HOME/security-dashboard-backup"/*/ | head -1)
    if [ -n "$LATEST_BACKUP" ]; then
        echo "✅ Latest backup: $(basename $LATEST_BACKUP)"
    else
        echo "⚠️  No backups found"
    fi
else
    echo "⚠️  Backup directory not found"
fi

echo ""
echo "✅ Verification complete!"
