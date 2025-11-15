#!/bin/bash
# {{PROJECT_NAME}} Android - Project Bootstrap
# Creates complete Android Studio project structure

set -e

PROJECT_ROOT="{{PROJECT_ROOT}}/android"
APP_NAME="{{ANDROID_PROJECT_NAME}}"
PACKAGE_NAME="{{ANDROID_PACKAGE}}"
GITHUB_REMOTE="{{ANDROID_GITHUB_REPO}}"

echo "🚀 {{PROJECT_NAME}} Android - Project Bootstrap"
echo "============================================"
echo "Creating Android project at: $PROJECT_ROOT"
echo "Package: $PACKAGE_NAME"
echo "GitHub: $GITHUB_REMOTE"
echo ""

cd "$PROJECT_ROOT"

# Remove old project if exists
if [ -d "$APP_NAME" ]; then
    echo "⚠️  Removing existing $APP_NAME directory..."
    rm -rf "$APP_NAME"
fi

# Create main directory structure
echo "📁 Creating directory structure..."
mkdir -p "$APP_NAME"/{app,gradle/wrapper}
mkdir -p "$APP_NAME/app/src"/{main,test,androidTest}
mkdir -p "$APP_NAME/app/src/main"/{java/{{ANDROID_PACKAGE_PATH}},res,assets}
mkdir -p "$APP_NAME/app/src/main/java/{{ANDROID_PACKAGE_PATH}}"/{models,services,ui,managers,utils}
mkdir -p "$APP_NAME/app/src/main/java/{{ANDROID_PACKAGE_PATH}}/ui"/{activities,fragments,adapters,views}
mkdir -p "$APP_NAME/app/src/main/res"/{layout,values,mipmap-anydpi-v26,drawable}

echo "✅ Directories created"
echo ""

# Create placeholder app icons using XML drawables
echo "📝 Creating placeholder app icons..."

# Create ic_launcher.xml (adaptive icon background)
cat > "$APP_NAME/app/src/main/res/drawable/ic_launcher_background.xml" << 'ICONEOF'
<?xml version="1.0" encoding="utf-8"?>
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    <path
        android:fillColor="#2196F3"
        android:pathData="M0,0h108v108h-108z" />
</vector>
ICONEOF

# Create ic_launcher_foreground.xml
cat > "$APP_NAME/app/src/main/res/drawable/ic_launcher_foreground.xml" << 'ICONEOF'
<?xml version="1.0" encoding="utf-8"?>
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    <group
        android:scaleX="0.5"
        android:scaleY="0.5"
        android:translateX="27"
        android:translateY="27">
        <path
            android:fillColor="#FFFFFF"
            android:pathData="M54,27L54,81M27,54L81,54"
            android:strokeWidth="6"
            android:strokeColor="#FFFFFF" />
    </group>
</vector>
ICONEOF

# Create ic_launcher.xml (adaptive icon)
cat > "$APP_NAME/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml" << 'ICONEOF'
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@drawable/ic_launcher_background" />
    <foreground android:drawable="@drawable/ic_launcher_foreground" />
</adaptive-icon>
ICONEOF

# Create ic_launcher_round.xml (adaptive icon round)
cat > "$APP_NAME/app/src/main/res/mipmap-anydpi-v26/ic_launcher_round.xml" << 'ICONEOF'
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@drawable/ic_launcher_background" />
    <foreground android:drawable="@drawable/ic_launcher_foreground" />
</adaptive-icon>
ICONEOF

echo "✅ Placeholder icons created"

# Create root build.gradle.kts
echo "📝 Creating root build.gradle.kts..."
cat > "$APP_NAME/build.gradle.kts" << 'GRADLEEOF'
// Top-level build file
plugins {
    id("com.android.application") version "8.2.0" apply false
    id("org.jetbrains.kotlin.android") version "1.9.20" apply false
}

tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}
GRADLEEOF

# Create settings.gradle.kts
echo "📝 Creating settings.gradle.kts..."
cat > "$APP_NAME/settings.gradle.kts" << 'GRADLEEOF'
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "{{PROJECT_NAME}}"
include(":app")
GRADLEEOF

# Create app/build.gradle.kts
echo "📝 Creating app/build.gradle.kts..."
cat > "$APP_NAME/app/build.gradle.kts" << 'GRADLEEOF'
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("kotlin-kapt")
}

android {
    namespace = "{{ANDROID_PACKAGE}}"
    compileSdk = 34

    defaultConfig {
        applicationId = "{{ANDROID_PACKAGE}}"
        minSdk = 26
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildFeatures {
        viewBinding = true
    }
}

dependencies {
    // Core Android
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("com.google.android.material:material:1.11.0")
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")
    
    // Lifecycle
    implementation("androidx.lifecycle:lifecycle-viewmodel-ktx:2.7.0")
    implementation("androidx.lifecycle:lifecycle-livedata-ktx:2.7.0")
    
    // Maps & Location
    implementation("com.google.android.gms:play-services-maps:18.2.0")
    implementation("com.google.android.gms:play-services-location:21.1.0")
    
    // Networking
    implementation("com.squareup.retrofit2:retrofit:2.9.0")
    implementation("com.squareup.retrofit2:converter-gson:2.9.0")
    implementation("com.squareup.okhttp3:okhttp:4.12.0")
    implementation("com.squareup.okhttp3:logging-interceptor:4.12.0")
    
    // Coroutines
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.3")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-play-services:1.7.3")
    
    // Room Database
    implementation("androidx.room:room-runtime:2.6.1")
    implementation("androidx.room:room-ktx:2.6.1")
    kapt("androidx.room:room-compiler:2.6.1")
    
    // WorkManager (background tasks)
    implementation("androidx.work:work-runtime-ktx:2.9.0")
    
    // Testing
    testImplementation("junit:junit:4.13.2")
    androidTestImplementation("androidx.test.ext:junit:1.1.5")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.5.1")
}
GRADLEEOF

# Create gradle.properties
echo "📝 Creating gradle.properties..."
cat > "$APP_NAME/gradle.properties" << 'GRADLEEOF'
# Project-wide Gradle settings
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
android.useAndroidX=true
android.enableJetifier=true
kotlin.code.style=official
android.nonTransitiveRClass=true
GRADLEEOF

# Create gradle-wrapper.properties
echo "📝 Creating gradle-wrapper.properties..."
cat > "$APP_NAME/gradle/wrapper/gradle-wrapper.properties" << 'GRADLEEOF'
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.2-bin.zip
networkTimeout=10000
validateDistributionUrl=true
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
GRADLEEOF

# Download gradle-wrapper.jar
echo "📦 Downloading gradle-wrapper.jar..."
curl -L -s -o "$APP_NAME/gradle/wrapper/gradle-wrapper.jar" \
    https://raw.githubusercontent.com/gradle/gradle/v8.2.0/gradle/wrapper/gradle-wrapper.jar

# Create gradlew script
echo "📝 Creating gradlew..."
curl -L -s -o "$APP_NAME/gradlew" \
    https://raw.githubusercontent.com/gradle/gradle/v8.2.0/gradlew

# Create gradlew.bat
curl -L -s -o "$APP_NAME/gradlew.bat" \
    https://raw.githubusercontent.com/gradle/gradle/v8.2.0/gradlew.bat

# Make gradlew executable
chmod +x "$APP_NAME/gradlew"

# Create proguard-rules.pro
echo "📝 Creating proguard-rules.pro..."
cat > "$APP_NAME/app/proguard-rules.pro" << 'PROGUARDEOF'
# Add project specific ProGuard rules here.
-keepattributes *Annotation*
-keepclassmembers class * {
    @androidx.annotation.Keep *;
}
PROGUARDEOF

# Create AndroidManifest.xml
echo "📝 Creating AndroidManifest.xml..."
cat > "$APP_NAME/app/src/main/AndroidManifest.xml" << 'MANIFESTEOF'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- Permissions -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    
    <!-- Features -->
    <uses-feature android:name="android.hardware.location.gps" android:required="false" />

    <application
        android:name=".{{PROJECT_NAME}}Application"
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.{{PROJECT_NAME}}">
        
        <activity
            android:name=".ui.activities.MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>

</manifest>
MANIFESTEOF

# Create {{PROJECT_NAME}}Application.kt
echo "📝 Creating {{PROJECT_NAME}}Application.kt..."
cat > "$APP_NAME/app/src/main/java/{{ANDROID_PACKAGE_PATH}}/{{PROJECT_NAME}}Application.kt" << 'KTEOF'
package {{ANDROID_PACKAGE}}

import android.app.Application

class {{PROJECT_NAME}}Application : Application() {
    
    override fun onCreate() {
        super.onCreate()
        // Initialize app-wide components here
    }
}
KTEOF

# Create MainActivity.kt
echo "📝 Creating MainActivity.kt..."
cat > "$APP_NAME/app/src/main/java/{{ANDROID_PACKAGE_PATH}}/ui/activities/MainActivity.kt" << 'KTEOF'
package {{ANDROID_PACKAGE}}.ui.activities

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import {{ANDROID_PACKAGE}}.R
import {{ANDROID_PACKAGE}}.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {
    
    private lateinit var binding: ActivityMainBinding
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
        
        setupUI()
    }
    
    private fun setupUI() {
        supportActionBar?.title = "{{PROJECT_NAME}}"
    }
}
KTEOF

# Create activity_main.xml - using a different delimiter to avoid conflicts
echo "📝 Creating activity_main.xml..."
cat > "$APP_NAME/app/src/main/res/layout/activity_main.xml" << 'XMLEOF'
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout 
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

    <TextView
        android:id="@+id/textView"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="{{PROJECT_NAME}}"
        android:textSize="24sp"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toTopOf="parent" />

</androidx.constraintlayout.widget.ConstraintLayout>
XMLEOF

# Create strings.xml
echo "📝 Creating strings.xml..."
cat > "$APP_NAME/app/src/main/res/values/strings.xml" << 'XMLEOF'
<resources>
    <string name="app_name">{{PROJECT_NAME}}</string>
</resources>
XMLEOF

# Create colors.xml
echo "📝 Creating colors.xml..."
cat > "$APP_NAME/app/src/main/res/values/colors.xml" << 'XMLEOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="black">#FF000000</color>
    <color name="white">#FFFFFFFF</color>
    <color name="excellent">#4CAF50</color>
    <color name="good">#8BC34A</color>
    <color name="fair">#FF9800</color>
    <color name="poor">#FF5722</color>
    <color name="restricted">#F44336</color>
</resources>
XMLEOF

# Create themes.xml
echo "📝 Creating themes.xml..."
cat > "$APP_NAME/app/src/main/res/values/themes.xml" << 'XMLEOF'
<resources>
    <style name="Theme.{{PROJECT_NAME}}" parent="Theme.MaterialComponents.DayNight.DarkActionBar">
        <item name="colorPrimary">#2196F3</item>
        <item name="colorPrimaryDark">#1976D2</item>
        <item name="colorAccent">#FF9800</item>
    </style>
</resources>
XMLEOF

# Create .gitignore
echo "📝 Creating .gitignore..."
cat > "$APP_NAME/.gitignore" << 'GITEOF'
# Built application files
*.apk
*.ap_
*.aab

# Files for the ART/Dalvik VM
*.dex

# Java class files
*.class

# Generated files
bin/
gen/
out/
release/

# Gradle files
.gradle/
build/

# Local configuration file (sdk path, etc)
local.properties

# Proguard folder generated by Eclipse
proguard/

# Log Files
*.log

# Android Studio Navigation editor temp files
.navigation/

# Android Studio captures folder
captures/

# IntelliJ
*.iml
.idea/
misc.xml
deploymentTargetDropDown.xml
render.experimental.xml

# Keystore files
*.jks
*.keystore

# External native build folder generated in Android Studio 2.2 and later
.externalNativeBuild
.cxx/

# Google Services (e.g. APIs or Firebase)
google-services.json

# Freeline
freeline.py
freeline/
freeline_project_description.json

# fastlane
fastlane/report.xml
fastlane/Preview.html
fastlane/screenshots
fastlane/test_output
fastlane/readme.md

# Version control
vcs.xml

# Secrets
secrets/
*.key
*.pem
GITEOF

# Initialize Git repository
echo ""
echo "📦 Initializing Git repository..."
cd "$APP_NAME"
git init
git remote add origin "$GITHUB_REMOTE"
cd ..

echo ""
echo "✅ Android Project Bootstrap Complete!"
echo ""
echo "📊 Project Structure:"
echo "   $PROJECT_ROOT/$APP_NAME/"
echo ""
echo "📦 Git Remote:"
echo "   $GITHUB_REMOTE"
echo ""
echo "🔨 Next Steps:"
echo "   1. cd $APP_NAME"
echo "   2. ./gradlew assembleDebug"
echo "   3. git add . && git commit -m \"Initial Android project\""
echo "   4. git push -u origin main"
echo ""
echo "🚀 Ready for Claude Code prompts!"
