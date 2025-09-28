# Personal iOS Build Plan for Themby

## Quick Start Guide for Personal Use

This is a streamlined plan to get Themby running on your personal iPhone, skipping App Store preparation.

## Prerequisites
- Mac with Xcode installed
- iOS device connected with developer account (free Apple ID works)
- Flutter development environment

## Phase 1: Essential Dependencies (30 minutes)

### 1.1 Update pubspec.yaml
Add iOS media kit support:
```yaml
dependencies:
  # Existing dependencies...
  media_kit_libs_ios_video: ^1.1.1  # Add this line
```

### 1.2 Install dependencies
```bash
flutter clean
flutter pub get
cd ios && pod install && cd ..
```

## Phase 2: Fix Blocking Issues (45 minutes)

### 2.1 iOS Deployment Target
**File:** `ios/Podfile`
```ruby
platform :ios, '13.0'
```

### 2.2 Fix Android-only code
**File:** `lib/app.dart` - Line 23
**Replace:**
```dart
if (Platform.isAndroid){
  await FlutterDisplayMode.setHighRefreshRate();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    statusBarColor: Colors.transparent,
  ));
}
```

**With:**
```dart
if (Platform.isAndroid){
  await FlutterDisplayMode.setHighRefreshRate();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    statusBarColor: Colors.transparent,
  ));
} else if (Platform.isIOS) {
  // Basic iOS status bar styling
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
  ));
}
```

### 2.3 Fix External Player Feature
**File:** `lib/src/features/emby/presentation/widgets/share_button.dart` - Line 48

**Wrap Android-only code:**
```dart
void openMxPlayer(String videoUrl) async {
  if (Platform.isAndroid) {
    final intent = AndroidIntent(
      action: 'action_view',
      data: videoUrl,
      type: "video/*",
    );

    try {
      await intent.launch();
    } catch (e) {
      print('无法打开 MX Player: $e');
    }
  } else {
    // iOS - just show a message for now
    SmartDialog.showToast('外部播放器功能在 iOS 上暂不支持');
  }
}
```

## Phase 3: iOS Network Permissions (5 minutes)

**File:** `ios/Runner/Info.plist`
Add before `</dict>`:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

## Phase 4: Build and Install (15 minutes)

### 4.1 Generate Code
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 4.2 Build for iOS
```bash
flutter build ios --debug --no-codesign
```

### 4.3 Install on Device
```bash
# Connect your iPhone and trust the computer
flutter run -d [your-device-name]

# Or use Xcode:
# 1. Open ios/Runner.xcworkspace in Xcode
# 2. Select your device
# 3. Hit Run button
```

### 4.4 Trust Developer (On iPhone)
After installation:
1. Go to Settings > General > VPN & Device Management
2. Find your Apple ID under Developer App
3. Tap "Trust [Your Apple ID]"

## What Will Work Immediately
- ✅ Browse Emby libraries
- ✅ Search media
- ✅ Video playback with Media Kit
- ✅ Favorites and history
- ✅ Settings and themes
- ✅ All UI and navigation

## What Won't Work (Can Skip for Now)
- ❌ External player sharing (Android-specific)
- ❌ High refresh rate optimization
- ❌ Some Android-specific UI optimizations

## Troubleshooting

### Build Errors
```bash
# If you get pod errors:
cd ios
rm Podfile.lock
rm -rf Pods
pod install
cd ..

# If Media Kit errors:
flutter clean
flutter pub get
cd ios && pod install && cd ..
```

### Device Not Recognized
```bash
# Check connected devices
flutter devices

# If not showing, check:
# 1. iPhone is unlocked
# 2. "Trust This Computer" was tapped
# 3. Developer mode enabled (iOS 16+)
```

### Code Signing Issues
For personal use, free Apple ID works fine:
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner project
3. Go to "Signing & Capabilities"
4. Choose your Apple ID team
5. Xcode will auto-fix bundle identifier

## Total Time Estimate: 1.5 hours

## Quick Test Checklist
After successful build:
- [ ] App launches without crashes
- [ ] Can connect to your Emby server
- [ ] Can browse and search media
- [ ] Video playback works
- [ ] Audio plays correctly
- [ ] Navigation works smoothly

## Next Steps (Optional Improvements)
If everything works well, you can later:
1. Add iOS-specific external player support (VLC, Infuse)
2. Optimize UI for iOS (Safe Area, haptics)
3. Add background audio support
4. Improve iOS-specific theming

The core functionality should work perfectly for personal use!