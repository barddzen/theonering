#!/bin/bash
# Show current status and recent history
# iOS-specific version with build checks

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
if [ -f "FlightReadyIOS.xcodeproj/project.pbxproj" ]; then
    echo "Checking if project builds..."
    if xcodebuild -scheme FlightReadyIOS -quiet clean build 2>&1 | grep -q "BUILD SUCCEEDED"; then
        echo "✅ Project builds successfully"
    else
        echo "❌ Project has build errors"
        echo "Run: xcodebuild -scheme FlightReadyIOS clean build"
    fi
else
    echo "⚠️  No Xcode project found"
fi
