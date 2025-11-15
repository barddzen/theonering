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

### Usage

```bash
# 1. Create project directory
mkdir MyNewProject
cd MyNewProject

# 2. Pull TheOneRing template
git clone https://github.com/barddzen/TheOneRing.git .
rm -rf .git

# 3. Run the generator
./theonering.sh \
  --project "MyNewProject" \
  --bundle "com.company.myapp" \
  --github-user "YOUR_USERNAME"
```

### Example

```bash
mkdir FlightReady
cd FlightReady
git clone https://github.com/barddzen/TheOneRing.git .
rm -rf .git

./theonering.sh \
  --project "FlightReady" \
  --bundle "com.hookedonyutz.flightready" \
  --github-user "barddzen"
```

## What Gets Created

```
YourProject/
├── ios/
│   ├── YourProjectIOS/              # Complete Xcode project
│   │   ├── YourProjectIOS.xcodeproj
│   │   └── YourProjectIOS/          # Source code
│   ├── scripts/                     # Helper scripts (commit, status, etc.)
│   └── templates/                   # Claude Code prompts
└── android/
    ├── YourProjectAndroid/          # Complete Android project
    │   ├── app/
    │   ├── build.gradle.kts
    │   └── gradlew
    ├── scripts/                     # Helper scripts
    └── templates/                   # Claude Code prompts
```

## Helper Scripts

Both iOS and Android have these helper scripts in their `scripts/` folders:

- `commit.sh "message"` - Quick commit with message
- `status.sh` - Show git status and recent commits
- `tag-daily.sh` - Create date-based tag (e.g., 2024-11-15)
- `tag-feature.sh "name"` - Create feature tag
- `push-all.sh` - Push commits and tags to GitHub

## Troubleshooting

### "Repository not found" when pushing

You forgot to create the GitHub repos first! Create them:
- `https://github.com/YOUR_USER/YourProjectIOS`
- `https://github.com/YOUR_USER/YourProjectAndroid`

Then push manually:
```bash
cd ios/YourProjectIOS
git push -u origin main

cd ../../android/YourProjectAndroid
git push -u origin main
```

### iOS build fails

Open the Xcode project and set your development team:
1. Open `YourProjectIOS.xcodeproj` in Xcode
2. Select project → Target → Signing & Capabilities
3. Select your team

### Android build fails

Make sure you have JDK 17 installed:
```bash
java -version  # Should show version 17
```

## Full Documentation

See [NEWPROJECT.md](NEWPROJECT.md) for complete step-by-step instructions.

## License

MIT - Use this however you want for your projects!
