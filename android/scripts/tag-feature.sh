#!/bin/bash
# Feature complete tag - creates a feature tag
# Android-specific version

cd "$(dirname "$0")/.."

if [ -z "$1" ]; then
    echo "❌ Error: Feature name required"
    echo "Usage: ./scripts/tag-feature.sh \"feature-name\""
    echo "Example: ./scripts/tag-feature.sh \"map-view-complete\""
    exit 1
fi

FEATURE_TAG="android-feature-$1"

echo "🏷️  Creating feature tag: $FEATURE_TAG"
echo ""

# Create annotated tag
git tag -a "$FEATURE_TAG" -m "Android Feature complete: $1"

echo "✅ Tag created!"
echo ""
echo "Recent Android feature tags:"
git tag -l "android-feature-*" | tail -10
echo ""
echo "💡 To push tags: ./scripts/push-all.sh"
