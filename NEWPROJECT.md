# Creating a New Project with TheOneRing

## Prerequisites

Before starting, you must:
1. **Create TWO new GitHub repositories** for your project:
   - `https://github.com/YOUR_USERNAME/YourProjectIOS`
   - `https://github.com/YOUR_USERNAME/YourProjectAndroid`
   
   **Important:** Create these FIRST before running the script!

---

## The Workflow

### Step 1: Create Project Directory
```bash
cd /Users/davidyutzy/Development
mkdir MyNewProject
cd MyNewProject
```

### Step 2: Pull TheOneRing Template
```bash
git clone https://github.com/barddzen/TheOneRing.git .
rm -rf .git  # Remove TheOneRing's git history
```

### Step 3: Run theonering.sh
```bash
./theonering.sh \
  --project "MyNewProject" \
  --bundle "com.company.myapp" \
  --github-user "barddzen"
```

**What this script does:**
1. Validates your inputs
2. Modifies bootstrap scripts with your project-specific values
3. Runs iOS bootstrap → creates complete Xcode project
4. Runs Android bootstrap → creates complete Android Studio project
5. Initializes git repositories for both iOS and Android
6. Sets up git remotes pointing to your GitHub repos
7. Creates initial commits
8. Attempts to push to GitHub

### Step 4: If Push Fails (You Forgot to Create Repos)

If the script fails at the push step, it will remind you:

```
❌ Push failed! Did you create the GitHub repositories?

Please create:
  - https://github.com/barddzen/MyNewProjectIOS
  - https://github.com/barddzen/MyNewProjectAndroid

Then run:
  cd ios/MyNewProjectIOS && git push -u origin main
  cd ../../android/MyNewProjectAndroid && git push -u origin main
```

After creating the repos, just run the push commands manually.

---

## Complete Example

```bash
# 1. Create repos on GitHub first:
#    - https://github.com/barddzen/FlightReadyIOS
#    - https://github.com/barddzen/FlightReadyAndroid

# 2. Create project directory
cd /Users/davidyutzy/Development
mkdir FlightReady
cd FlightReady

# 3. Pull template
git clone https://github.com/barddzen/TheOneRing.git .
rm -rf .git

# 4. Run the magic script
./theonering.sh \
  --project "FlightReady" \
  --bundle "com.hookedonyutz.flightready" \
  --github-user "barddzen"

# 5. Done! You now have:
#    - FlightReady/ios/FlightReadyIOS/ (buildable Xcode project)
#    - FlightReady/android/FlightReadyAndroid/ (buildable Android project)
#    - Both pushed to GitHub
```

---

## What Gets Created

After running `theonering.sh`, your project structure will be:

```
MyNewProject/
├── ios/
│   ├── MyNewProjectIOS/           # Complete Xcode project
│   │   ├── MyNewProjectIOS.xcodeproj
│   │   ├── MyNewProjectIOS/       # Source code
│   │   └── .git/                  # Git repo (pushed to GitHub)
│   ├── scripts/                   # Helper scripts
│   └── templates/                 # CC prompt templates
└── android/
    ├── MyNewProjectAndroid/       # Complete Android project
    │   ├── app/
    │   ├── build.gradle.kts
    │   ├── gradlew
    │   └── .git/                  # Git repo (pushed to GitHub)
    ├── scripts/                   # Helper scripts
    └── templates/                 # CC prompt templates
```

---

## Troubleshooting

### "Repository not found" error
- You forgot to create the GitHub repos first
- Create them, then manually push:
  ```bash
  cd ios/MyNewProjectIOS
  git push -u origin main
  
  cd ../../android/MyNewProjectAndroid
  git push -u origin main
  ```

### "Build failed" error
- **iOS:** Open the Xcode project and set your development team in Signing & Capabilities
- **Android:** Check that you have JDK 17 installed

### Scripts not executable
```bash
chmod +x theonering.sh
chmod +x ios/scripts/*.sh
chmod +x android/scripts/*.sh
```

---

## Remember

**ALWAYS create the GitHub repos BEFORE running `theonering.sh`!**

It saves time and prevents confusion at the end.
