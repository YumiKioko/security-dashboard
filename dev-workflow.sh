#!/bin/bash

# Security Dashboard Development Workflow
cd ~/security-dashboard

case "$1" in
    "status")
        echo "📊 Current Git status:"
        git status
        ;;
    "commit")
        if [ -z "$2" ]; then
            echo "Please provide a commit message"
            echo "Usage: ./dev-workflow.sh commit 'Your message'"
            exit 1
        fi
        git add .
        git commit -m "$2"
        ;;
    "log")
        git log --oneline -10
        ;;
    "backup")
        ./backup-with-git.sh
        ;;
    "start")
        node server-complete.js
        ;;
    "restore")
        LATEST_BACKUP=$(ls -td ~/security-dashboard-backup/*/ | head -1)
        if [ -n "$LATEST_BACKUP" ]; then
            ./restore-with-git.sh "$LATEST_BACKUP"
        else
            echo "No backup found"
        fi
        ;;
    *)
        echo "Security Dashboard Development Workflow"
        echo "Commands:"
        echo "  status    - Show Git status"
        echo "  commit    - Commit changes (provide message)"
        echo "  log       - Show recent commits"
        echo "  backup    - Create backup"
        echo "  start     - Start server"
        echo "  restore   - Restore from latest backup"
        echo ""
        echo "Example: ./dev-workflow.sh commit 'Fixed compliance page'"
        ;;
esac
