#!/bin/bash
# Quick commit - stages all changes and commits with a message
# iOS-specific version

cd "$(dirname "$0")/.."

if [ -z "$1" ]; then
    echo "❌ Error: Commit message required"
    echo "Usage: ./scripts/commit.sh \"your commit message\""
    exit 1
fi

echo "📝 Staging all changes..."
git add .

# Double-check critical iOS files are staged
echo "📦 Verifying critical iOS files..."
git add -f FlightReadyIOS.xcodeproj/project.pbxproj 2>/dev/null || true
git add -f FlightReadyIOS/App/Info.plist 2>/dev/null || true
git add -f FlightReadyIOS.xcodeproj/xcshareddata/xcschemes/*.xcscheme 2>/dev/null || true

# Verify Xcode project isn't corrupted
echo "🔍 Verifying Xcode project integrity..."
if [ -f "FlightReadyIOS.xcodeproj/project.pbxproj" ]; then
    if plutil -lint FlightReadyIOS.xcodeproj/project.pbxproj > /dev/null 2>&1; then
        echo "   ✅ project.pbxproj is valid"
    else
        echo "   ⚠️  Warning: project.pbxproj may be corrupted"
        read -p "   Continue commit anyway? (y/N) " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "❌ Commit cancelled"
            exit 1
        fi
    fi
fi

echo "💾 Committing..."
git commit -m "ios-$1"

echo "✅ Commit complete!"
echo ""
git log -1 --oneline

# Show what was committed
echo ""
echo "📊 Files committed:"
git diff-tree --no-commit-id --name-only -r HEAD | head -30
