# TheOneRing

Universal iOS + Android mobile project generator. One script to create them all.

## What This Does

TheOneRing creates complete, buildable iOS and Android projects with:
- ✅ Complete Xcode project (Swift/UIKit)
- ✅ Complete Android Studio project (Kotlin)
- ✅ Git repositories initialized and pushed to GitHub
- ✅ Helper scripts for development workflow
- ✅ Claude Code prompt templates

## Quick Start

### Prerequisites

1. **Xcode** (for iOS development)
2. **Android Studio** or JDK 17 (for Android development)
3. **Create GitHub repositories FIRST:**
   - `https://github.com/YOUR_USERNAME/YourProjectIOS`
   - `https://github.com/YOUR_USERNAME/YourProjectAndroid`

### One-Command Setup
```bash
cd /Users/yourname/Development

curl -O https://raw.githubusercontent.com/barddzen/TheOneRing/main/theonering.sh
chmod +x theonering.sh

./theonering.sh \
  --project "MyNewProject" \
  --bundle "com.company.myapp" \
  --github-user "YOUR_USERNAME"
```

**That's it!** The script creates everything, builds both platforms, and pushes to GitHub.

### Example
```bash
cd /Users/davidyutzy/Development

curl -O https://raw.githubusercontent.com/barddzen/TheOneRing/main/theonering.sh
chmod +x theonering.sh

./theonering.sh \
  --project "FlightReady" \
  --bundle "com.hookedonyutz.flightready" \
  --github-user "barddzen"
```

## What Gets Created
```
YourProject/
├── bootstrap.sh                     # Universal bootstrap script
├── theonering.sh                    # Generator script
├── ios/
│   ├── YourProjectIOS.xcodeproj     # Complete Xcode project
│   ├── YourProjectIOS/              # Source code
│   ├── .git/                        # Pushed to GitHub
│   ├── scripts/                     # Helper scripts
│   │   ├── commit.sh
│   │   ├── status.sh
│   │   ├── tag-daily.sh
│   │   ├── tag-feature.sh
│   │   └── push-all.sh
│   └── templates/                   # Claude Code prompts
│       ├── CC_PROMPT_TEMPLATE_SIMPLE_IOS.md
│       ├── CC_PROMPT_TEMPLATE_MEDIUM_IOS.md
│       └── CC_PROMPT_TEMPLATE_COMPLEX_IOS.md
└── android/
    ├── YourProjectAndroid/          # Complete Android project
    │   ├── app/
    │   ├── build.gradle.kts
    │   ├── gradlew
    │   └── .git/                    # Pushed to GitHub
    ├── scripts/                     # Helper scripts
    └── templates/                   # Claude Code prompts
```

## How It Works

1. **Downloads template** - Clones TheOneRing into your project folder
2. **Runs bootstrap** - Calls `bootstrap.sh` twice (once for iOS, once for Android) with your project details
3. **Builds projects** - Verifies both Xcode and Android projects compile
4. **Pushes to GitHub** - Commits and force pushes to your repos

**No placeholders. No sed replacements. Just clean argument passing.**

## Helper Scripts

Both iOS and Android include helper scripts for common git operations:

### iOS
```bash
cd ios

# Quick commit
./scripts/commit.sh "Added feature"

# Check status  
./scripts/status.sh

# Create date tag (e.g., 2024-11-15)
./scripts/tag-daily.sh

# Create feature tag
./scripts/tag-feature.sh "v1.0-beta"

# Push everything
./scripts/push-all.sh
```

### Android
```bash
cd android/YourProjectAndroid

# Same commands, relative path
../scripts/commit.sh "Added feature"
../scripts/status.sh
../scripts/tag-daily.sh
../scripts/tag-feature.sh "v1.0-beta"
../scripts/push-all.sh
```

## Claude Code Integration

Each platform includes ready-to-use prompt templates:

- `CC_PROMPT_TEMPLATE_SIMPLE_*.md` - For small, focused tasks
- `CC_PROMPT_TEMPLATE_MEDIUM_*.md` - For moderate complexity features
- `CC_PROMPT_TEMPLATE_COMPLEX_*.md` - For major architectural work

These templates understand your project structure and include best practices for mobile development.

## Troubleshooting

### "Repository not found" when pushing

You forgot to create the GitHub repos! Create them:
- `https://github.com/YOUR_USER/YourProjectIOS`
- `https://github.com/YOUR_USER/YourProjectAndroid`

Then manually push:
```bash
cd YourProject/ios
git push -u origin main --force

cd ../android/YourProjectAndroid
git push -u origin main --force
```

### iOS build fails or "needs team config"

**This is normal!** Open the Xcode project and set your development team:
1. Open `YourProjectIOS.xcodeproj` in Xcode
2. Select project → Target → Signing & Capabilities
3. Select your team

### Android build fails

Check you have JDK 17:
```bash
java -version  # Should show version 17
```

The project was still created successfully - it just needs the right JDK to build.

### Android build fails during theonering.sh

**This is often expected on first run!** The build verification might fail due to:
- Gradle downloading dependencies for the first time
- Network/proxy configuration
- JDK version

**The project was still created successfully.** To verify:
```bash
cd FlightReady/android/FlightReadyAndroid
./gradlew assembleDebug
```

If this succeeds, your Android project is fine! The initial failure was just a Gradle setup issue.

### "Directory already exists"

You already have a project with that name:
```bash
rm -rf YourProject  # Delete it
# Or use a different name
```

## Architecture

TheOneRing uses a simple, argument-based approach:
```bash
theonering.sh
    ↓
    Calls: bootstrap.sh --platform ios --project-name "..." --bundle "..." 
    ↓
    Calls: bootstrap.sh --platform android --project-name "..." --package "..."
    ↓
    Done!
```

No templates with placeholders. No sed replacements. Just one bootstrap script that handles both platforms based on arguments.

## Full Documentation

See [NEWPROJECT.md](NEWPROJECT.md) for complete step-by-step instructions and detailed examples.

## Why TheOneRing?

- **Fast** - New project in under 2 minutes
- **Complete** - Both platforms, fully configured
- **Clean** - No hardcoded values, just arguments
- **Integrated** - Git repos, helper scripts, Claude Code templates included
- **Simple** - One command does everything

## License

MIT - Use this however you want for your projects!

---

**One script to rule them all.** 🎯
