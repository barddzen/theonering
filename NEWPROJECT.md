# Creating a New Project with TheOneRing

## Prerequisites

Before starting, you must:
1. **Create TWO new GitHub repositories** for your project:
   - `https://github.com/YOUR_USERNAME/YourProjectIOS`
   - `https://github.com/YOUR_USERNAME/YourProjectAndroid`
   
   **Note:** It's okay if these repos have a README or license - the script will force push and overwrite them.

---

## The Workflow

### One Command Setup
```bash
cd /Users/davidyutzy/Development

curl -O https://raw.githubusercontent.com/barddzen/TheOneRing/main/theonering.sh
chmod +x theonering.sh

./theonering.sh \
  --project "MyNewProject" \
  --bundle "com.company.myapp" \
  --github-user "barddzen"
```

**That's it!** The script will:
1. Create `MyNewProject/` folder
2. Clone the TheOneRing template
3. Run iOS bootstrap → creates complete Xcode project
4. Run Android bootstrap → creates complete Android Studio project
5. Initialize git repositories for both platforms
6. Commit and force push to GitHub
7. Verify both projects build

---

## Complete Example
```bash
# 1. Create repos on GitHub first:
#    - https://github.com/barddzen/FlightReadyIOS
#    - https://github.com/barddzen/FlightReadyAndroid

# 2. Run one command
cd /Users/davidyutzy/Development

curl -O https://raw.githubusercontent.com/barddzen/TheOneRing/main/theonering.sh
chmod +x theonering.sh

./theonering.sh \
  --project "FlightReady" \
  --bundle "com.hookedonyutz.flightready" \
  --github-user "barddzen"

# 3. Done! You now have:
#    - FlightReady/ios/FlightReadyIOS/ (buildable Xcode project)
#    - FlightReady/android/FlightReadyAndroid/ (buildable Android project)
#    - Both pushed to GitHub
```

---

## What Gets Created

After running `theonering.sh`, your project structure will be:
```
MyNewProject/
├── bootstrap.sh                   # Universal bootstrap (used by theonering.sh)
├── theonering.sh                  # The script you ran
├── ios/
│   ├── FlightReadyIOS.xcodeproj   # Complete Xcode project
│   ├── FlightReadyIOS/            # Source code
│   ├── .git/                      # Git repo (pushed to GitHub)
│   ├── .gitignore
│   ├── scripts/                   # Helper scripts
│   │   ├── commit.sh
│   │   ├── status.sh
│   │   ├── tag-daily.sh
│   │   ├── tag-feature.sh
│   │   └── push-all.sh
│   └── templates/                 # Claude Code prompt templates
│       ├── CC_PROMPT_TEMPLATE_SIMPLE_IOS.md
│       ├── CC_PROMPT_TEMPLATE_MEDIUM_IOS.md
│       └── CC_PROMPT_TEMPLATE_COMPLEX_IOS.md
└── android/
    ├── FlightReadyAndroid/        # Complete Android project
    │   ├── app/
    │   ├── build.gradle.kts
    │   ├── gradlew
    │   ├── .git/                  # Git repo (pushed to GitHub)
    │   └── .gitignore
    ├── scripts/                   # Helper scripts
    │   ├── commit.sh
    │   ├── status.sh
    │   ├── tag-daily.sh
    │   ├── tag-feature.sh
    │   └── push-all.sh
    └── templates/                 # Claude Code prompt templates
        ├── CC_PROMPT_TEMPLATE_SIMPLE_ANDROID.md
        ├── CC_PROMPT_TEMPLATE_MEDIUM_ANDROID.md
        └── CC_PROMPT_TEMPLATE_COMPLEX_ANDROID.md
```

---

## Troubleshooting

### "Repository not found" error during push
- You forgot to create the GitHub repos first
- Create them at:
  - `https://github.com/YOUR_USER/YourProjectIOS`
  - `https://github.com/YOUR_USER/YourProjectAndroid`
- Then manually push:
```bash
  cd MyNewProject/ios
  git push -u origin main --force
  
  cd ../android/MyNewProjectAndroid
  git push -u origin main --force
```

### "iOS build failed" or "needs team config"
- **Expected!** Open the Xcode project and set your development team:
  1. Open `MyNewProjectIOS.xcodeproj` in Xcode
  2. Select project → Target → Signing & Capabilities
  3. Select your team
  4. Build should succeed

### "Android build failed"
- Check that you have JDK 17 installed:
```bash
  java -version  # Should show version 17
```
- The project was still created successfully, just needs JDK

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

### "Directory already exists" error
- You already have a project with that name
- Either delete it or use a different name:
```bash
  rm -rf MyNewProject
  # Or use a different name
```

### Scripts not executable
- Shouldn't happen, but if it does:
```bash
  chmod +x theonering.sh
  chmod +x bootstrap.sh
```

---

## Using the Helper Scripts

After project creation, each platform has helper scripts in its `scripts/` folder:

### iOS Helper Scripts
```bash
cd ios

# Quick commit
./scripts/commit.sh "Added new feature"

# Check status
./scripts/status.sh

# Create date-based tag
./scripts/tag-daily.sh

# Create feature tag
./scripts/tag-feature.sh "v1.0-beta"

# Push everything (commits + tags)
./scripts/push-all.sh
```

### Android Helper Scripts
```bash
cd android/FlightReadyAndroid

# Same scripts available
../scripts/commit.sh "Added new feature"
../scripts/status.sh
../scripts/tag-daily.sh
../scripts/tag-feature.sh "v1.0-beta"
../scripts/push-all.sh
```

---

## Next Steps After Creation

### iOS Development
1. Open `MyNewProjectIOS.xcodeproj` in Xcode
2. Set your development team (if you haven't already)
3. Use Claude Code with the prompt templates in `ios/templates/`
4. Build and run on simulator or device

### Android Development
1. Open `MyNewProjectAndroid/` in Android Studio
2. Sync Gradle files
3. Use Claude Code with the prompt templates in `android/templates/`
4. Build and run on emulator or device

---

## Remember

- ✅ Create GitHub repos FIRST (but it's okay if they have a README)
- ✅ The script handles everything - just run one command
- ✅ Force push means you don't need to worry about repo contents
- ✅ Helper scripts are included for easy git workflow
- ✅ Claude Code templates are ready to use

**TheOneRing makes starting new projects trivial!** 🎉
