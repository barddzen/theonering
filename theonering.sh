#!/bin/bash
# TheOneRing - Universal iOS + Android Project Generator

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Parse arguments
PROJECT_NAME=""
BUNDLE_BASE=""
GITHUB_USER=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --project)
            PROJECT_NAME="$2"
            shift 2
            ;;
        --bundle)
            BUNDLE_BASE="$2"
            shift 2
            ;;
        --github-user)
            GITHUB_USER="$2"
            shift 2
            ;;
        --help)
            echo "Usage: ./theonering.sh --project <name> --bundle <bundle-id-base> --github-user <username>"
            echo ""
            echo "Example:"
            echo "  ./theonering.sh --project FlightReady --bundle com.hookedonyutz.flightready --github-user barddzen"
            echo ""
            echo "IMPORTANT: Create GitHub repos FIRST:"
            echo "  - https://github.com/YOUR_USER/YourProjectIOS"
            echo "  - https://github.com/YOUR_USER/YourProjectAndroid"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Validate
if [ -z "$PROJECT_NAME" ] || [ -z "$BUNDLE_BASE" ] || [ -z "$GITHUB_USER" ]; then
    echo -e "${RED}❌ Missing required arguments${NC}"
    echo ""
    echo "Usage: ./theonering.sh --project <name> --bundle <bundle-id-base> --github-user <username>"
    exit 1
fi

# Derived values
IOS_PROJECT_NAME="${PROJECT_NAME}IOS"
ANDROID_PROJECT_NAME="${PROJECT_NAME}Android"
IOS_BUNDLE_ID="${BUNDLE_BASE}.ios"
ANDROID_PACKAGE="${BUNDLE_BASE}.android"
IOS_GITHUB_REPO="https://github.com/${GITHUB_USER}/${IOS_PROJECT_NAME}.git"
ANDROID_GITHUB_REPO="https://github.com/${GITHUB_USER}/${ANDROID_PROJECT_NAME}.git"

# Create project directory
if [ -d "$PROJECT_NAME" ]; then
    echo -e "${RED}❌ Directory $PROJECT_NAME already exists!${NC}"
    exit 1
fi

mkdir "$PROJECT_NAME"
cd "$PROJECT_NAME"
PROJECT_ROOT="$(pwd)"

# Download template
echo -e "${BLUE}📦 Downloading template...${NC}"
git clone https://github.com/${GITHUB_USER}/TheOneRing.git .
rm -rf .git
echo -e "${GREEN}✅ Template ready${NC}"
echo ""

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}       THE ONE RING - Project Setup      ${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${GREEN}Project:${NC}          $PROJECT_NAME"
echo -e "${GREEN}Bundle Base:${NC}      $BUNDLE_BASE"
echo -e "${GREEN}GitHub User:${NC}      $GITHUB_USER"
echo ""
echo -e "${GREEN}iOS:${NC}"
echo "  Project:        $IOS_PROJECT_NAME"
echo "  Bundle ID:      $IOS_BUNDLE_ID"
echo "  GitHub:         $IOS_GITHUB_REPO"
echo ""
echo -e "${GREEN}Android:${NC}"
echo "  Project:        $ANDROID_PROJECT_NAME"
echo "  Package:        $ANDROID_PACKAGE"
echo "  GitHub:         $ANDROID_GITHUB_REPO"
echo ""
echo -e "${YELLOW}⚠️  Make sure you created these GitHub repos FIRST!${NC}"
echo ""

# Make bootstrap executable
chmod +x bootstrap.sh

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}         Building iOS Project            ${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

./bootstrap.sh \
  --platform ios \
  --project-name "$PROJECT_NAME" \
  --bundle "$IOS_BUNDLE_ID" \
  --github-repo "$IOS_GITHUB_REPO" \
  --project-root "$PROJECT_ROOT"

echo ""
echo -e "${BLUE}🔨 Verifying iOS build...${NC}"
cd ios
if xcodebuild -project "${IOS_PROJECT_NAME}.xcodeproj" -scheme "$IOS_PROJECT_NAME" -quiet clean build 2>&1 | grep -q "BUILD SUCCEEDED"; then
    echo -e "${GREEN}✅ iOS build successful${NC}"
    IOS_SUCCESS=true
else
    echo -e "${YELLOW}⚠️  iOS needs development team configuration${NC}"
    echo -e "${YELLOW}   Open ${IOS_PROJECT_NAME}.xcodeproj and set your team${NC}"
    IOS_SUCCESS=false
fi
cd ..

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}        Building Android Project         ${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

./bootstrap.sh \
  --platform android \
  --project-name "$PROJECT_NAME" \
  --package "$ANDROID_PACKAGE" \
  --github-repo "$ANDROID_GITHUB_REPO" \
  --project-root "$PROJECT_ROOT"

echo ""
echo -e "${BLUE}🔨 Verifying Android build...${NC}"
cd android
if [ -d "$ANDROID_PROJECT_NAME" ] && [ -f "$ANDROID_PROJECT_NAME/gradlew" ]; then
    cd "$ANDROID_PROJECT_NAME"
    if ./gradlew assembleDebug --quiet 2>&1 | grep -q "BUILD SUCCESSFUL"; then
        echo -e "${GREEN}✅ Android build successful${NC}"
        ANDROID_SUCCESS=true
    else
        echo -e "${RED}❌ Android build failed${NC}"
        ANDROID_SUCCESS=false
    fi
    cd ..
else
    echo -e "${RED}❌ Android project not found${NC}"
    ANDROID_SUCCESS=false
fi
cd ..

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}          Pushing to GitHub             ${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Push iOS
echo -e "${BLUE}📤 Pushing iOS to GitHub...${NC}"
cd "ios"
if git add . && git commit -m "Initial iOS project" && git push -u origin main --force 2>&1; then
    echo -e "${GREEN}✅ iOS pushed to GitHub${NC}"
    IOS_PUSHED=true
else
    echo -e "${RED}❌ iOS push failed${NC}"
    echo -e "${YELLOW}Did you create https://github.com/${GITHUB_USER}/${IOS_PROJECT_NAME} ?${NC}"
    IOS_PUSHED=false
fi
cd ..

# Push Android
echo ""
echo -e "${BLUE}📤 Pushing Android to GitHub...${NC}"
cd "android/$ANDROID_PROJECT_NAME"
if git add . && git commit -m "Initial Android project" && git push -u origin main --force 2>&1; then
    echo -e "${GREEN}✅ Android pushed to GitHub${NC}"
    ANDROID_PUSHED=true
else
    echo -e "${RED}❌ Android push failed${NC}"
    echo -e "${YELLOW}Did you create https://github.com/${GITHUB_USER}/${ANDROID_PROJECT_NAME} ?${NC}"
    ANDROID_PUSHED=false
fi
cd ../..

# Summary
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}              Summary                    ${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ "$IOS_SUCCESS" = true ]; then
    echo -e "${GREEN}✅ iOS:     Built successfully${NC}"
else
    echo -e "${YELLOW}⚠️  iOS:     Needs team config${NC}"
fi

if [ "$IOS_PUSHED" = true ]; then
    echo -e "${GREEN}✅ iOS:     Pushed to GitHub${NC}"
else
    echo -e "${RED}❌ iOS:     Not pushed${NC}"
fi

echo ""

if [ "$ANDROID_SUCCESS" = true ]; then
    echo -e "${GREEN}✅ Android: Built successfully${NC}"
else
    echo -e "${RED}❌ Android: Build failed${NC}"
fi

if [ "$ANDROID_PUSHED" = true ]; then
    echo -e "${GREEN}✅ Android: Pushed to GitHub${NC}"
else
    echo -e "${RED}❌ Android: Not pushed${NC}"
fi

# Manual push instructions if needed
if [ "$IOS_PUSHED" = false ] || [ "$ANDROID_PUSHED" = false ]; then
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}     Push Failed - Manual Steps        ${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "Please create these GitHub repositories:"
    if [ "$IOS_PUSHED" = false ]; then
        echo "  - https://github.com/${GITHUB_USER}/${IOS_PROJECT_NAME}"
    fi
    if [ "$ANDROID_PUSHED" = false ]; then
        echo "  - https://github.com/${GITHUB_USER}/${ANDROID_PROJECT_NAME}"
    fi
    echo ""
    echo "Then push manually:"
    if [ "$IOS_PUSHED" = false ]; then
        echo "  cd ios"
        echo "  git push -u origin main"
        echo ""
    fi
    if [ "$ANDROID_PUSHED" = false ]; then
        echo "  cd android/${ANDROID_PROJECT_NAME}"
        echo "  git push -u origin main"
    fi
fi

echo ""
echo -e "${GREEN}🎉 Project ${PROJECT_NAME} created!${NC}"
echo ""
