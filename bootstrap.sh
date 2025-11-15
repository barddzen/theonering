#!/bin/bash
# Universal Bootstrap - Creates iOS or Android projects

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Parse arguments
PLATFORM=""
PROJECT_NAME=""
BUNDLE_ID=""
PACKAGE_NAME=""
GITHUB_REPO=""
PROJECT_ROOT=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --platform)
            PLATFORM="$2"
            shift 2
            ;;
        --project-name)
            PROJECT_NAME="$2"
            shift 2
            ;;
        --bundle)
            BUNDLE_ID="$2"
            shift 2
            ;;
        --package)
            PACKAGE_NAME="$2"
            shift 2
            ;;
        --github-repo)
            GITHUB_REPO="$2"
            shift 2
            ;;
        --project-root)
            PROJECT_ROOT="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Validate
if [ -z "$PLATFORM" ] || [ -z "$PROJECT_NAME" ] || [ -z "$GITHUB_REPO" ] || [ -z "$PROJECT_ROOT" ]; then
    echo -e "${RED}❌ Missing required arguments${NC}"
    exit 1
fi

if [ "$PLATFORM" = "ios" ]; then
    if [ -z "$BUNDLE_ID" ]; then
        echo -e "${RED}❌ iOS requires --bundle${NC}"
        exit 1
    fi
    
    # iOS-specific variables
    APP_NAME="${PROJECT_NAME}IOS"
    PLATFORM_ROOT="$PROJECT_ROOT/ios"
    
    echo -e "${BLUE}🚀 ${PROJECT_NAME} iOS - Project Bootstrap${NC}"
    echo "========================================"
    echo "Creating Xcode project at: $PLATFORM_ROOT"
    echo "Bundle ID: $BUNDLE_ID"
    echo "GitHub: $GITHUB_REPO"
    echo ""
    
    cd "$PLATFORM_ROOT"
    
    # Create directory structure
    echo "📁 Creating directory structure..."
    mkdir -p "$APP_NAME"/{App,Models,Services,Views,ViewControllers,Managers,Extensions,Resources,SupportingFiles}
    mkdir -p "${APP_NAME}Tests"
    mkdir -p "${APP_NAME}UITests"
    echo "✅ Directories created"
    echo ""
    
    # Create AppDelegate.swift
    echo "📝 Creating AppDelegate.swift..."
    cat > "$APP_NAME/App/AppDelegate.swift" << 'EOF'
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupAppearance()
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    private func setupAppearance() {
        UINavigationBar.appearance().prefersLargeTitles = true
    }
}
EOF

    # Create SceneDelegate.swift
    echo "📝 Creating SceneDelegate.swift..."
    cat > "$APP_NAME/App/SceneDelegate.swift" << EOF
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let mainViewController = UIViewController()
        mainViewController.view.backgroundColor = .systemBackground
        mainViewController.title = "$PROJECT_NAME"
        
        let navigationController = UINavigationController(rootViewController: mainViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}
EOF

    # Create Info.plist
    echo "📝 Creating Info.plist..."
    cat > "$APP_NAME/App/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>\$(DEVELOPMENT_LANGUAGE)</string>
    <key>CFBundleExecutable</key>
    <string>\$(EXECUTABLE_NAME)</string>
    <key>CFBundleIdentifier</key>
    <string>\$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>\$(PRODUCT_NAME)</string>
    <key>CFBundlePackageType</key>
    <string>\$(PRODUCT_BUNDLE_PACKAGE_TYPE)</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSRequiresIPhoneOS</key>
    <true/>
    <key>UIApplicationSceneManifest</key>
    <dict>
        <key>UIApplicationSupportsMultipleScenes</key>
        <false/>
        <key>UISceneConfigurations</key>
        <dict>
            <key>UIWindowSceneSessionRoleApplication</key>
            <array>
                <dict>
                    <key>UISceneConfigurationName</key>
                    <string>Default Configuration</string>
                    <key>UISceneDelegateClassName</key>
                    <string>\$(PRODUCT_MODULE_NAME).SceneDelegate</string>
                </dict>
            </array>
        </dict>
    </dict>
    <key>UIApplicationSupportsIndirectInputEvents</key>
    <true/>
    <key>UILaunchStoryboardName</key>
    <string>LaunchScreen</string>
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
    <key>UISupportedInterfaceOrientations~ipad</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationPortraitUpsideDown</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>$PROJECT_NAME needs your location to check airspace restrictions and weather conditions.</string>
    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>$PROJECT_NAME uses your location to monitor saved locations and send you alerts about changing conditions.</string>
    <key>UIBackgroundModes</key>
    <array>
        <string>location</string>
        <string>fetch</string>
        <string>remote-notification</string>
    </array>
</dict>
</plist>
EOF

    # Create LaunchScreen.storyboard
    echo "📝 Creating LaunchScreen.storyboard..."
    mkdir -p "$APP_NAME/Resources"
    cat > "$APP_NAME/Resources/LaunchScreen.storyboard" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<document type="com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB" version="3.0" toolsVersion="21701" targetRuntime="iOS.CocoaTouch" propertyAccessControl="none" useAutolayout="YES" launchScreen="YES" useTraitCollections="YES" useSafeAreas="YES" colorMatched="YES" initialViewController="01J-lp-oVM">
    <device id="retina6_1" orientation="portrait" appearance="light"/>
    <dependencies>
        <deployment identifier="iOS"/>
        <plugIn identifier="com.apple.InterfaceBuilder.IBCocoaTouchPlugin" version="21678"/>
        <capability name="Safe area layout guides" minToolsVersion="9.0"/>
        <capability name="documents saved in the Xcode 8 format" minToolsVersion="8.0"/>
    </dependencies>
    <scenes>
        <scene sceneID="EHf-IW-A2E">
            <objects>
                <viewController id="01J-lp-oVM" sceneMemberID="viewController">
                    <view key="view" contentMode="scaleToFill" id="Ze5-6b-2t3">
                        <rect key="frame" x="0.0" y="0.0" width="414" height="896"/>
                        <autoresizingMask key="autoresizingMask" widthSizable="YES" heightSizable="YES"/>
                        <subviews>
                            <label opaque="NO" clipsSubviews="YES" userInteractionEnabled="NO" contentMode="left" horizontalHuggingPriority="251" verticalHuggingPriority="251" text="$PROJECT_NAME" textAlignment="center" lineBreakMode="tailTruncation" baselineAdjustment="alignBaselines" minimumFontSize="18" translatesAutoresizingMaskIntoConstraints="NO" id="GJd-Yh-RWb">
                                <fontDescription key="fontDescription" type="boldSystem" pointSize="36"/>
                                <color key="textColor" systemColor="labelColor"/>
                                <nil key="highlightedColor"/>
                            </label>
                        </subviews>
                        <viewLayoutGuide key="safeArea" id="Bcu-3y-fUS"/>
                        <color key="backgroundColor" systemColor="systemBackgroundColor"/>
                        <constraints>
                            <constraint firstItem="GJd-Yh-RWb" firstAttribute="centerX" secondItem="Ze5-6b-2t3" secondAttribute="centerX" id="Q3B-4B-g5h"/>
                            <constraint firstItem="GJd-Yh-RWb" firstAttribute="centerY" secondItem="Ze5-6b-2t3" secondAttribute="centerY" id="akx-eg-2ui"/>
                        </constraints>
                    </view>
                </viewController>
                <placeholder placeholderIdentifier="IBFirstResponder" id="iYj-Kq-Ea1" userLabel="First Responder" sceneMemberID="firstResponder"/>
            </objects>
            <point key="canvasLocation" x="52.173913043478265" y="375"/>
        </scene>
    </scenes>
    <resources>
        <systemColor name="labelColor">
            <color white="0.0" alpha="1" colorSpace="custom" customColorSpace="genericGamma22GrayColorSpace"/>
        </systemColor>
        <systemColor name="systemBackgroundColor">
            <color white="1" alpha="1" colorSpace="custom" customColorSpace="genericGamma22GrayColorSpace"/>
        </systemColor>
    </resources>
</document>
EOF

    # Create Assets.xcassets
    echo "📝 Creating Assets.xcassets..."
    mkdir -p "$APP_NAME/Resources/Assets.xcassets/AppIcon.appiconset"
    cat > "$APP_NAME/Resources/Assets.xcassets/AppIcon.appiconset/Contents.json" << 'EOF'
{
  "images" : [
    {
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "20x20"
    },
    {
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "20x20"
    },
    {
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "29x29"
    },
    {
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "29x29"
    },
    {
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "40x40"
    },
    {
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "40x40"
    },
    {
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "60x60"
    },
    {
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "60x60"
    },
    {
      "idiom" : "ipad",
      "scale" : "1x",
      "size" : "20x20"
    },
    {
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "20x20"
    },
    {
      "idiom" : "ipad",
      "scale" : "1x",
      "size" : "29x29"
    },
    {
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "29x29"
    },
    {
      "idiom" : "ipad",
      "scale" : "1x",
      "size" : "40x40"
    },
    {
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "40x40"
    },
    {
      "idiom" : "ipad",
      "scale" : "1x",
      "size" : "76x76"
    },
    {
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "76x76"
    },
    {
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "83.5x83.5"
    },
    {
      "idiom" : "ios-marketing",
      "scale" : "1x",
      "size" : "1024x1024"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

    cat > "$APP_NAME/Resources/Assets.xcassets/Contents.json" << 'EOF'
{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

    # Create Xcode project.pbxproj
    echo "📝 Creating project.pbxproj..."
    mkdir -p "$APP_NAME.xcodeproj"
    
    cat > "$APP_NAME.xcodeproj/project.pbxproj" << PBXPROJ
// !$*UTF8*$!
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 56;
	objects = {
		AA0000 /* $APP_NAME.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = $APP_NAME.app; sourceTree = BUILT_PRODUCTS_DIR; };
		AA0002 /* AppDelegate.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = AppDelegate.swift; sourceTree = "<group>"; };
		AA0004 /* SceneDelegate.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = SceneDelegate.swift; sourceTree = "<group>"; };
		AA0006 /* Assets.xcassets */ = {isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = Assets.xcassets; sourceTree = "<group>"; };
		AA0008 /* LaunchScreen.storyboard */ = {isa = PBXFileReference; lastKnownFileType = file.storyboard; path = LaunchScreen.storyboard; sourceTree = "<group>"; };
		AA0009 /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };
		AA0011 = {
			isa = PBXGroup;
			children = (
				AA0012 /* $APP_NAME */,
				AA0013 /* Products */,
			);
			sourceTree = "<group>";
		};
		AA0012 /* $APP_NAME */ = {
			isa = PBXGroup;
			children = (
				AA0014 /* App */,
				AA0015 /* Models */,
				AA0016 /* Services */,
				AA0017 /* Views */,
				AA0018 /* ViewControllers */,
				AA0019 /* Managers */,
				AA0020 /* Extensions */,
				AA0021 /* Resources */,
				AA0009 /* Info.plist */,
			);
			path = $APP_NAME;
			sourceTree = "<group>";
		};
		AA0013 /* Products */ = {
			isa = PBXGroup;
			children = (
				AA0000 /* $APP_NAME.app */,
			);
			name = Products;
			sourceTree = "<group>";
		};
		AA0014 /* App */ = {
			isa = PBXGroup;
			children = (
				AA0002 /* AppDelegate.swift */,
				AA0004 /* SceneDelegate.swift */,
			);
			path = App;
			sourceTree = "<group>";
		};
		AA0015 /* Models */ = {
			isa = PBXGroup;
			children = (
			);
			path = Models;
			sourceTree = "<group>";
		};
		AA0016 /* Services */ = {
			isa = PBXGroup;
			children = (
			);
			path = Services;
			sourceTree = "<group>";
		};
		AA0017 /* Views */ = {
			isa = PBXGroup;
			children = (
			);
			path = Views;
			sourceTree = "<group>";
		};
		AA0018 /* ViewControllers */ = {
			isa = PBXGroup;
			children = (
			);
			path = ViewControllers;
			sourceTree = "<group>";
		};
		AA0019 /* Managers */ = {
			isa = PBXGroup;
			children = (
			);
			path = Managers;
			sourceTree = "<group>";
		};
		AA0020 /* Extensions */ = {
			isa = PBXGroup;
			children = (
			);
			path = Extensions;
			sourceTree = "<group>";
		};
		AA0021 /* Resources */ = {
			isa = PBXGroup;
			children = (
				AA0006 /* Assets.xcassets */,
				AA0008 /* LaunchScreen.storyboard */,
			);
			path = Resources;
			sourceTree = "<group>";
		};
		AA0022 /* $APP_NAME */ = {
			isa = PBXNativeTarget;
			buildConfigurationList = AA0023;
			buildPhases = (
				AA0024 /* Sources */,
				AA0010 /* Frameworks */,
				AA0025 /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
			);
			name = $APP_NAME;
			productName = $APP_NAME;
			productReference = AA0000 /* $APP_NAME.app */;
			productType = "com.apple.product-type.application";
		};
		AA0026 /* Project object */ = {
			isa = PBXProject;
			attributes = {
				BuildIndependentTargetsInParallel = 1;
				LastSwiftUpdateCheck = 1500;
				LastUpgradeCheck = 1500;
			};
			buildConfigurationList = AA0027;
			compatibilityVersion = "Xcode 14.0";
			developmentRegion = en;
			hasScannedForEncodings = 0;
			knownRegions = (
				en,
				Base,
			);
			mainGroup = AA0011;
			productRefGroup = AA0013 /* Products */;
			projectDirPath = "";
			projectRoot = "";
			targets = (
				AA0022 /* $APP_NAME */,
			);
		};
		AA0024 /* Sources */ = {
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				AA0003 /* SceneDelegate.swift in Sources */,
				AA0001 /* AppDelegate.swift in Sources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
		AA0025 /* Resources */ = {
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				AA0007 /* LaunchScreen.storyboard in Resources */,
				AA0005 /* Assets.xcassets in Resources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
		AA0010 /* Frameworks */ = {
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
		AA0023 /* Build configuration list for PBXNativeTarget "$APP_NAME" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				AA0030 /* Debug */,
				AA0031 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
		AA0027 /* Build configuration list for PBXProject "$APP_NAME" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				AA0028 /* Debug */,
				AA0029 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
		AA0028 /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEBUG_INFORMATION_FORMAT = dwarf;
				ENABLE_TESTABILITY = YES;
				GCC_OPTIMIZATION_LEVEL = 0;
				IPHONEOS_DEPLOYMENT_TARGET = 15.0;
				MARKETING_VERSION = 1.0;
				ONLY_ACTIVE_ARCH = YES;
				SDKROOT = iphoneos;
				SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG;
				SWIFT_OPTIMIZATION_LEVEL = "-Onone";
				SWIFT_VERSION = 5.0;
			};
			name = Debug;
		};
		AA0029 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
				ENABLE_NS_ASSERTIONS = NO;
				IPHONEOS_DEPLOYMENT_TARGET = 15.0;
				MARKETING_VERSION = 1.0;
				SDKROOT = iphoneos;
				SWIFT_COMPILATION_MODE = wholemodule;
				SWIFT_OPTIMIZATION_LEVEL = "-O";
				SWIFT_VERSION = 5.0;
				VALIDATE_PRODUCT = YES;
			};
			name = Release;
		};
		AA0030 /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = $APP_NAME/App/Info.plist;
				INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
				INFOPLIST_KEY_UILaunchStoryboardName = LaunchScreen;
				INFOPLIST_KEY_UISupportedInterfaceOrientations = "UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				IPHONEOS_DEPLOYMENT_TARGET = 15.0;
				LD_RUNPATH_SEARCH_PATHS = (
					"\$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = $BUNDLE_ID;
				PRODUCT_NAME = "\$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			};
			name = Debug;
		};
		AA0031 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = $APP_NAME/App/Info.plist;
				INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
				INFOPLIST_KEY_UILaunchStoryboardName = LaunchScreen;
				INFOPLIST_KEY_UISupportedInterfaceOrientations = "UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				IPHONEOS_DEPLOYMENT_TARGET = 15.0;
				LD_RUNPATH_SEARCH_PATHS = (
					"\$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = $BUNDLE_ID;
				PRODUCT_NAME = "\$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			};
			name = Release;
		};
		AA0001 /* AppDelegate.swift in Sources */ = {isa = PBXBuildFile; fileRef = AA0002; };
		AA0003 /* SceneDelegate.swift in Sources */ = {isa = PBXBuildFile; fileRef = AA0004; };
		AA0005 /* Assets.xcassets in Resources */ = {isa = PBXBuildFile; fileRef = AA0006; };
		AA0007 /* LaunchScreen.storyboard in Resources */ = {isa = PBXBuildFile; fileRef = AA0008; };
	};
	rootObject = AA0026 /* Project object */;
}
PBXPROJ

    # Create xcscheme
    echo "📝 Creating xcscheme..."
    mkdir -p "$APP_NAME.xcodeproj/xcshareddata/xcschemes"
    cat > "$APP_NAME.xcodeproj/xcshareddata/xcschemes/$APP_NAME.xcscheme" << XCSCHEME
<?xml version="1.0" encoding="UTF-8"?>
<Scheme
   LastUpgradeVersion = "1500"
   version = "1.7">
   <BuildAction
      parallelizeBuildables = "YES"
      buildImplicitDependencies = "YES">
      <BuildActionEntries>
         <BuildActionEntry
            buildForTesting = "YES"
            buildForRunning = "YES"
            buildForProfiling = "YES"
            buildForArchiving = "YES"
            buildForAnalyzing = "YES">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "AA0022"
               BuildableName = "$APP_NAME.app"
               BlueprintName = "$APP_NAME"
               ReferencedContainer = "container:$APP_NAME.xcodeproj">
            </BuildableReference>
         </BuildActionEntry>
      </BuildActionEntries>
   </BuildAction>
   <TestAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      shouldUseLaunchSchemeArgsEnv = "YES"
      shouldAutocreateTestPlan = "YES">
   </TestAction>
   <LaunchAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      launchStyle = "0"
      useCustomWorkingDirectory = "NO"
      ignoresPersistentStateOnLaunch = "NO"
      debugDocumentVersioning = "YES"
      debugServiceExtension = "internal"
      allowLocationSimulation = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "AA0022"
            BuildableName = "$APP_NAME.app"
            BlueprintName = "$APP_NAME"
            ReferencedContainer = "container:$APP_NAME.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </LaunchAction>
   <ProfileAction
      buildConfiguration = "Release"
      shouldUseLaunchSchemeArgsEnv = "YES"
      savedToolIdentifier = ""
      useCustomWorkingDirectory = "NO"
      debugDocumentVersioning = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "AA0022"
            BuildableName = "$APP_NAME.app"
            BlueprintName = "$APP_NAME"
            ReferencedContainer = "container:$APP_NAME.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </ProfileAction>
   <AnalyzeAction
      buildConfiguration = "Debug">
   </AnalyzeAction>
   <ArchiveAction
      buildConfiguration = "Release"
      revealArchiveInOrganizer = "YES">
   </ArchiveAction>
</Scheme>
XCSCHEME

    # Create .gitignore
    echo "📝 Creating .gitignore..."
    cat > ".gitignore" << 'EOF'
# Xcode
*.xcuserstate
*.xcuserdatad/
xcuserdata/
*.moved-aside
DerivedData/
*.hmap
*.ipa
*.dSYM.zip
*.dSYM

# Swift Package Manager
.build/
Packages/
Package.pins
Package.resolved
*.swiftpm

# CocoaPods
Pods/
*.podspec

# Carthage
Carthage/Build/

# Fastlane
fastlane/report.xml
fastlane/Preview.html
fastlane/screenshots/**/*.png
fastlane/test_output

# Code coverage
*.profdata
*.profraw

# OS
.DS_Store
Thumbs.db

# Secrets
secrets/
*.key
*.pem
Config.plist
EOF

    # Initialize Git
    echo ""
    echo "📦 Initializing Git repository..."
    git init
    git remote add origin "$GITHUB_REPO"
    
    echo ""
    echo -e "${GREEN}✅ iOS Project Bootstrap Complete!${NC}"
    echo ""
    echo "📊 Project Structure:"
    echo "   $PLATFORM_ROOT/$APP_NAME.xcodeproj"
    echo "   $PLATFORM_ROOT/$APP_NAME/"
    echo ""
    echo "📦 Git Remote: $GITHUB_REPO"
    
elif [ "$PLATFORM" = "android" ]; then
    if [ -z "$PACKAGE_NAME" ]; then
        echo -e "${RED}❌ Android requires --package${NC}"
        exit 1
    fi
    
    # Android-specific variables
    APP_NAME="${PROJECT_NAME}Android"
    PLATFORM_ROOT="$PROJECT_ROOT/android"
    PACKAGE_PATH=$(echo "$PACKAGE_NAME" | tr '.' '/')
    
    echo -e "${BLUE}🚀 ${PROJECT_NAME} Android - Project Bootstrap${NC}"
    echo "============================================"
    echo "Creating Android project at: $PLATFORM_ROOT"
    echo "Package: $PACKAGE_NAME"
    echo "GitHub: $GITHUB_REPO"
    echo ""
    
    cd "$PLATFORM_ROOT"
    
    # Remove old project if exists
    if [ -d "$APP_NAME" ]; then
        echo "⚠️  Removing existing $APP_NAME directory..."
        rm -rf "$APP_NAME"
    fi
    
    # Create directory structure
    echo "📁 Creating directory structure..."
    mkdir -p "$APP_NAME"/{app,gradle/wrapper}
    mkdir -p "$APP_NAME/app/src"/{main,test,androidTest}
    mkdir -p "$APP_NAME/app/src/main"/{java/$PACKAGE_PATH,res,assets}
    mkdir -p "$APP_NAME/app/src/main/java/$PACKAGE_PATH"/{models,services,ui,managers,utils}
    mkdir -p "$APP_NAME/app/src/main/java/$PACKAGE_PATH/ui"/{activities,fragments,adapters,views}
    mkdir -p "$APP_NAME/app/src/main/res"/{layout,values,mipmap-anydpi-v26,drawable}
    echo "✅ Directories created"
    echo ""
    
    # Create placeholder app icons
    echo "🎨 Creating placeholder app icons..."
    cat > "$APP_NAME/app/src/main/res/drawable/ic_launcher_background.xml" << 'EOF'
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
EOF

    cat > "$APP_NAME/app/src/main/res/drawable/ic_launcher_foreground.xml" << 'EOF'
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
EOF

    cat > "$APP_NAME/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@drawable/ic_launcher_background" />
    <foreground android:drawable="@drawable/ic_launcher_foreground" />
</adaptive-icon>
EOF

    cat > "$APP_NAME/app/src/main/res/mipmap-anydpi-v26/ic_launcher_round.xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@drawable/ic_launcher_background" />
    <foreground android:drawable="@drawable/ic_launcher_foreground" />
</adaptive-icon>
EOF
    echo "✅ Placeholder icons created"
    
    # Create build.gradle.kts
    echo "📝 Creating build.gradle.kts..."
    cat > "$APP_NAME/build.gradle.kts" << 'EOF'
plugins {
    id("com.android.application") version "8.2.0" apply false
    id("org.jetbrains.kotlin.android") version "1.9.20" apply false
}

tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}
EOF

    # Create settings.gradle.kts
    cat > "$APP_NAME/settings.gradle.kts" << SETTINGSEOF
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

rootProject.name = "$PROJECT_NAME"
include(":app")
SETTINGSEOF

    # Create app/build.gradle.kts
    cat > "$APP_NAME/app/build.gradle.kts" << APPBUILDEOF
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("kotlin-kapt")
}

android {
    namespace = "$PACKAGE_NAME"
    compileSdk = 34

    defaultConfig {
        applicationId = "$PACKAGE_NAME"
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
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("com.google.android.material:material:1.11.0")
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")
    implementation("androidx.lifecycle:lifecycle-viewmodel-ktx:2.7.0")
    implementation("androidx.lifecycle:lifecycle-livedata-ktx:2.7.0")
    implementation("com.google.android.gms:play-services-maps:18.2.0")
    implementation("com.google.android.gms:play-services-location:21.1.0")
    implementation("com.squareup.retrofit2:retrofit:2.9.0")
    implementation("com.squareup.retrofit2:converter-gson:2.9.0")
    implementation("com.squareup.okhttp3:okhttp:4.12.0")
    implementation("com.squareup.okhttp3:logging-interceptor:4.12.0")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.3")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-play-services:1.7.3")
    implementation("androidx.room:room-runtime:2.6.1")
    implementation("androidx.room:room-ktx:2.6.1")
    kapt("androidx.room:room-compiler:2.6.1")
    implementation("androidx.work:work-runtime-ktx:2.9.0")
    
    testImplementation("junit:junit:4.13.2")
    androidTestImplementation("androidx.test.ext:junit:1.1.5")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.5.1")
}
APPBUILDEOF

    # Create gradle.properties
    cat > "$APP_NAME/gradle.properties" << 'EOF'
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
android.useAndroidX=true
android.enableJetifier=true
kotlin.code.style=official
android.nonTransitiveRClass=true
EOF

    # Create gradle-wrapper.properties
    cat > "$APP_NAME/gradle/wrapper/gradle-wrapper.properties" << 'EOF'
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.2-bin.zip
networkTimeout=10000
validateDistributionUrl=true
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
EOF

    # Download gradle wrapper files
    echo "📦 Downloading Gradle wrapper..."
    curl -L -s -o "$APP_NAME/gradle/wrapper/gradle-wrapper.jar" \
        https://raw.githubusercontent.com/gradle/gradle/v8.2.0/gradle/wrapper/gradle-wrapper.jar
    curl -L -s -o "$APP_NAME/gradlew" \
        https://raw.githubusercontent.com/gradle/gradle/v8.2.0/gradlew
    curl -L -s -o "$APP_NAME/gradlew.bat" \
        https://raw.githubusercontent.com/gradle/gradle/v8.2.0/gradlew.bat
    chmod +x "$APP_NAME/gradlew"
    
    # Create proguard-rules.pro
    cat > "$APP_NAME/app/proguard-rules.pro" << 'EOF'
-keepattributes *Annotation*
-keepclassmembers class * {
    @androidx.annotation.Keep *;
}
EOF

    # Create AndroidManifest.xml
    cat > "$APP_NAME/app/src/main/AndroidManifest.xml" << MANIFESTEOF
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    
    <uses-feature android:name="android.hardware.location.gps" android:required="false" />

    <application
        android:name=".${PROJECT_NAME}Application"
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.${PROJECT_NAME}">
        
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

    # Create Application class
    cat > "$APP_NAME/app/src/main/java/$PACKAGE_PATH/${PROJECT_NAME}Application.kt" << APPCLASSEOF
package $PACKAGE_NAME

import android.app.Application

class ${PROJECT_NAME}Application : Application() {
    
    override fun onCreate() {
        super.onCreate()
    }
}
APPCLASSEOF

    # Create MainActivity
    cat > "$APP_NAME/app/src/main/java/$PACKAGE_PATH/ui/activities/MainActivity.kt" << MAINACTIVITYEOF
package ${PACKAGE_NAME}.ui.activities

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import ${PACKAGE_NAME}.R
import ${PACKAGE_NAME}.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {
    
    private lateinit var binding: ActivityMainBinding
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
        
        setupUI()
    }
    
    private fun setupUI() {
        supportActionBar?.title = "$PROJECT_NAME"
    }
}
MAINACTIVITYEOF

    # Create activity_main.xml
    cat > "$APP_NAME/app/src/main/res/layout/activity_main.xml" << LAYOUTEOF
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
        android:text="$PROJECT_NAME"
        android:textSize="24sp"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toTopOf="parent" />

</androidx.constraintlayout.widget.ConstraintLayout>
LAYOUTEOF

    # Create strings.xml
    cat > "$APP_NAME/app/src/main/res/values/strings.xml" << STRINGSEOF
<resources>
    <string name="app_name">$PROJECT_NAME</string>
</resources>
STRINGSEOF

    # Create colors.xml
    cat > "$APP_NAME/app/src/main/res/values/colors.xml" << 'EOF'
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
EOF

    # Create themes.xml
    cat > "$APP_NAME/app/src/main/res/values/themes.xml" << THEMESEOF
<resources>
    <style name="Theme.$PROJECT_NAME" parent="Theme.MaterialComponents.DayNight.DarkActionBar">
        <item name="colorPrimary">#2196F3</item>
        <item name="colorPrimaryDark">#1976D2</item>
        <item name="colorAccent">#FF9800</item>
    </style>
</resources>
THEMESEOF

    # Create .gitignore
    cat > "$APP_NAME/.gitignore" << 'EOF'
*.apk
*.ap_
*.aab
*.dex
*.class
bin/
gen/
out/
release/
.gradle/
build/
local.properties
proguard/
*.log
.navigation/
captures/
*.iml
.idea/
misc.xml
deploymentTargetDropDown.xml
render.experimental.xml
*.jks
*.keystore
.externalNativeBuild
.cxx/
google-services.json
freeline.py
freeline/
freeline_project_description.json
fastlane/report.xml
fastlane/Preview.html
fastlane/screenshots
fastlane/test_output
fastlane/readme.md
vcs.xml
secrets/
*.key
*.pem
EOF

    # Initialize Git
    echo ""
    echo "📦 Initializing Git repository..."
    cd "$APP_NAME"
    git init
    git remote add origin "$GITHUB_REPO"
    cd ..
    
    echo ""
    echo -e "${GREEN}✅ Android Project Bootstrap Complete!${NC}"
    echo ""
    echo "📊 Project Structure:"
    echo "   $PLATFORM_ROOT/$APP_NAME/"
    echo ""
    echo "📦 Git Remote: $GITHUB_REPO"
    
else
    echo -e "${RED}❌ Invalid platform: $PLATFORM${NC}"
    echo "Must be 'ios' or 'android'"
    exit 1
fi
