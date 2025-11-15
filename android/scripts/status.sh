#!/bin/bash
# Show current status and recent history
# Android-specific version with Gradle build checks

cd "$(dirname "$0")/.."

echo "📊 Git Status"
echo "════════════════════════════════════════"
git status -s
echo ""

echo "📝 Recent Commits (last 5)"
echo "════════════════════════════════════════"
git log --oneline -5
echo ""

echo "🏷️  Recent Tags (last 5)"
echo "════════════════════════════════════════"
git tag -l | tail -5
echo ""

echo "🌿 Current Branch"
echo "════════════════════════════════════════"
git branch --show-current
echo ""

echo "🔄 Uncommitted Changes"
echo "════════════════════════════════════════"
git diff --stat
echo ""

echo "🔨 Build Status"
echo "════════════════════════════════════════"
if [ -d "FlightReadyAndroid" ]; then
    echo "Checking if project builds..."
    cd FlightReadyAndroid
    if ./gradlew assembleDebug --quiet 2>&1 | grep -q "BUILD SUCCESSFUL"; then
        echo "✅ Project builds successfully"
    else
        echo "❌ Project has build errors"
        echo "Run: cd FlightReadyAndroid && ./gradlew assembleDebug"
    fi
    cd ..
else
    echo "⚠️  No Android project found"
fi
