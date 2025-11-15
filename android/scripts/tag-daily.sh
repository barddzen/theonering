#!/bin/bash
# End of day tag - creates a dated tag with optional message
# Android-specific version

cd "$(dirname "$0")/.."

# Generate today's date tag with android prefix
DATE_TAG="android-daily-$(date +%Y%m%d)"

# Optional message
MESSAGE="${1:-End of day checkpoint - Android}"

echo "🏷️  Creating tag: $DATE_TAG"
echo "📝 Message: $MESSAGE"
echo ""

# Create annotated tag
git tag -a "$DATE_TAG" -m "$MESSAGE"

echo "✅ Tag created!"
echo ""
echo "Recent Android daily tags:"
git tag -l "android-daily-*" | tail -5
echo ""
echo "💡 To push tags: ./scripts/push-all.sh"
