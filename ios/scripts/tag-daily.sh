#!/bin/bash
# End of day tag - creates a dated tag with optional message
# iOS-specific version

cd "$(dirname "$0")/.."

# Generate today's date tag with ios prefix
DATE_TAG="ios-daily-$(date +%Y%m%d)"

# Optional message
MESSAGE="${1:-End of day checkpoint - iOS}"

echo "🏷️  Creating tag: $DATE_TAG"
echo "📝 Message: $MESSAGE"
echo ""

# Create annotated tag
git tag -a "$DATE_TAG" -m "$MESSAGE"

echo "✅ Tag created!"
echo ""
echo "Recent iOS daily tags:"
git tag -l "ios-daily-*" | tail -5
echo ""
echo "💡 To push tags: ./scripts/push-all.sh"
