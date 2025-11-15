#!/bin/bash
# Push everything - commits, tags, and pushes to remote

cd "$(dirname "$0")/.."

echo "🚀 Pushing commits and tags to remote..."
echo ""

# Check if remote is configured
if ! git remote | grep -q origin; then
    echo "❌ No git remote configured"
    echo "Expected: https://github.com/barddzen/FlightReadyAndroid.git"
    echo "Run: git remote add origin https://github.com/barddzen/FlightReadyAndroid.git"
    exit 1
fi

# Check if there are uncommitted changes
if [[ -n $(git status -s) ]]; then
    echo "⚠️  Warning: You have uncommitted changes!"
    git status -s
    echo ""
    read -p "Continue push anyway? (y/N) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Push cancelled"
        exit 1
    fi
fi

# Push commits
echo "📤 Pushing commits..."
git push

echo ""

# Push tags
echo "🏷️  Pushing tags..."
git push origin --tags

echo ""
echo "✅ Push complete!"
echo ""
echo "📊 Remote status:"
git log --oneline -3
