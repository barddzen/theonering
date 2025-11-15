#!/bin/bash
# Quick commit - stages all changes and commits with a message
# Android-specific version

cd "$(dirname "$0")/.."

if [ -z "$1" ]; then
    echo "❌ Error: Commit message required"
    echo "Usage: ./scripts/commit.sh \"your commit message\""
    exit 1
fi

echo "📝 Staging all changes..."
git add .

# Double-check critical Android files are staged
echo "📦 Verifying critical Android files..."
git add -f FlightReadyAndroid/app/build.gradle.kts 2>/dev/null || true
git add -f FlightReadyAndroid/app/src/main/AndroidManifest.xml 2>/dev/null || true
git add -f FlightReadyAndroid/gradle.properties 2>/dev/null || true
git add -f FlightReadyAndroid/settings.gradle.kts 2>/dev/null || true
git add -f FlightReadyAndroid/build.gradle.kts 2>/dev/null || true

# Verify Gradle build files are valid
echo "🔍 Verifying Gradle build files..."
if [ -f "FlightReadyAndroid/build.gradle.kts" ]; then
    if grep -q "plugins {" FlightReadyAndroid/build.gradle.kts; then
        echo "   ✅ build.gradle.kts looks valid"
    else
        echo "   ⚠️  Warning: build.gradle.kts may be corrupted"
        read -p "   Continue commit anyway? (y/N) " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "❌ Commit cancelled"
            exit 1
        fi
    fi
fi

echo "💾 Committing..."
git commit -m "android-$1"

echo "✅ Commit complete!"
echo ""
git log -1 --oneline

# Show what was committed
echo ""
echo "📊 Files committed:"
git diff-tree --no-commit-id --name-only -r HEAD | head -30
