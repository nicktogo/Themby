# iOS Build Plan for Themby

## Overview
This document outlines the step-by-step plan to build an iOS version of the Themby Flutter app, which is currently Android-focused. The app is a third-party Emby media player built with Flutter, Riverpod, and Media Kit.

## Current Status
- ✅ iOS project structure exists (`ios/` directory)
- ✅ Core Flutter dependencies are cross-platform compatible
- ⚠️ Several Android-specific dependencies need modification
- ⚠️ Platform-specific code needs iOS support

## Phase 1: Dependency Audit and Updates

### 1.1 Update Media Kit for iOS
**Current:**
```yaml
media_kit: ^1.1.11
media_kit_video: ^1.2.5
media_kit_libs_video: 1.0.5
```

**Required Changes:**
```yaml
media_kit: ^1.1.11
media_kit_video: ^1.2.5
media_kit_libs_video: 1.0.5
media_kit_libs_ios_video: ^1.1.1  # Add iOS-specific package
```

### 1.2 Handle Android-Only Dependencies
**Problematic Dependencies:**
- `android_intent_plus: ^5.1.0` - Used for external player integration
- `flutter_displaymode: ^0.6.0` - High refresh rate (may not work on iOS)

**Solution:** Wrap usage in platform checks and provide iOS alternatives.

### 1.3 Cross-Platform Dependencies (Already Compatible)
- ✅ `flutter_riverpod: ^2.5.1`
- ✅ `go_router: ^14.2.3`
- ✅ `dio: ^5.5.0+1`
- ✅ `objectbox: ^4.0.1`
- ✅ `cached_network_image: ^3.3.1`
- ✅ `media_kit` ecosystem
- ✅ All UI and state management packages

## Phase 2: iOS Configuration

### 2.1 Update iOS Deployment Target
**File:** `ios/Runner.xcodeproj/project.pbxproj`
```xml
IPHONEOS_DEPLOYMENT_TARGET = 13.0;
```
*Required for Media Kit iOS support*

### 2.2 Update Info.plist
**File:** `ios/Runner/Info.plist`
```xml
<!-- Add network permissions for Emby server connection -->
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>

<!-- Background audio playback -->
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
</array>
```

### 2.3 Podfile Updates
**File:** `ios/Podfile`
```ruby
platform :ios, '13.0'

# Add if needed for Media Kit
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
```

## Phase 3: Code Modifications

### 3.1 Platform-Specific System UI Code
**File:** `lib/app.dart`

**Current (Android-only):**
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

**Updated (Cross-platform):**
```dart
if (Platform.isAndroid) {
  await FlutterDisplayMode.setHighRefreshRate();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    statusBarColor: Colors.transparent,
  ));
} else if (Platform.isIOS) {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
  ));
}
```

### 3.2 External Player Integration
**File:** `lib/src/features/emby/presentation/widgets/share_button.dart`

**Current Issue:** Uses `android_intent_plus` exclusively

**Solution:** Create platform-specific implementations
```dart
void openExternalPlayer(String url) async {
  if (Platform.isAndroid) {
    // Existing Android Intent implementation
    final intent = AndroidIntent(/*...*/);
    await intent.launch();
  } else if (Platform.isIOS) {
    // iOS URL scheme implementation
    final schemes = [
      'vlc-x-callback://x-callback-url/stream?url=$url',
      'infuse://x-callback-url/play?url=$url',
      'nplayer-http://$url',
    ];

    for (String scheme in schemes) {
      if (await canLaunchUrlString(scheme)) {
        await launchUrlString(scheme);
        return;
      }
    }
    SmartDialog.showToast('No compatible video player found');
  }
}
```

### 3.3 Player Controller Updates
**File:** `lib/src/features/player/service/themby_controller.dart`

**Current:** Android-specific font handling
```dart
if (Platform.isAndroid) {
  // Font setup for subtitles
}
```

**Add iOS Support:**
```dart
if (Platform.isAndroid) {
  // Existing Android font setup
} else if (Platform.isIOS) {
  // iOS subtitle font configuration
  nativePlayer.setProperty("sub-font", "Helvetica");
}
```

## Phase 4: Testing Strategy

### 4.1 Build Verification
```bash
# Clean and get dependencies
flutter clean
flutter pub get

# Generate code (important for Riverpod)
flutter packages pub run build_runner build --delete-conflicting-outputs

# iOS-specific commands
cd ios && pod install && cd ..

# Build for iOS
flutter build ios --no-codesign
```

### 4.2 iOS Simulator Testing
```bash
flutter run -d "iPhone 15 Pro"
```

### 4.3 Device Testing
```bash
flutter run -d [device-id]
flutter build ios --release
```

## Phase 5: iOS-Specific Features & Optimizations

### 5.1 Native iOS Video Players
**Add support for popular iOS video players:**
- VLC for Mobile
- Infuse 7
- nPlayer
- PlayerXtreme Media Player

### 5.2 iOS UI Guidelines
- **Safe Area handling:** Ensure proper layout with notches/Dynamic Island
- **Dark Mode:** Test Material 3 theme compatibility
- **Haptic Feedback:** iOS-specific haptic patterns
- **Context Menus:** Replace Android-style long press with iOS context menus

### 5.3 Background Audio
Configure for background audio playback when app is minimized.

## Phase 6: App Store Preparation

### 6.1 Bundle Identifier
Update `ios/Runner.xcodeproj` with unique bundle ID:
```
com.themby.ios
```

### 6.2 App Icons
Ensure all iOS app icon sizes are provided in:
`ios/Runner/Assets.xcassets/AppIcon.appiconset/`

### 6.3 Privacy Permissions
Add required permissions for:
- Network access (Emby server connection)
- Local storage (ObjectBox database)
- Background audio playback

## Phase 7: Known Limitations & Workarounds

### 7.1 Features That Won't Work on iOS
- **MX Player Integration:** Android-only
- **Display Mode Control:** Android-specific high refresh rate
- **System UI Edge-to-Edge:** Different implementation needed

### 7.2 Alternative Solutions
- **External Players:** Use iOS URL schemes instead of Android Intents
- **System Integration:** Use iOS-specific APIs for similar functionality
- **Performance:** Leverage iOS hardware acceleration differently

## Phase 8: Build Pipeline

### 8.1 Development Build
```bash
flutter build ios --debug --no-codesign
```

### 8.2 Release Build
```bash
flutter build ios --release
```

### 8.3 Xcode Archive
Use Xcode for final App Store submission with proper code signing.

## Timeline Estimation

| Phase | Duration | Dependencies |
|-------|----------|--------------|
| Phase 1: Dependencies | 2-3 hours | Update pubspec.yaml, resolve conflicts |
| Phase 2: iOS Config | 1-2 hours | iOS development setup |
| Phase 3: Code Changes | 4-6 hours | Platform-specific implementations |
| Phase 4: Testing | 2-4 hours | iOS device/simulator access |
| Phase 5: Optimization | 4-8 hours | iOS-specific features |
| Phase 6: App Store Prep | 2-3 hours | Developer account required |

**Total Estimated Time:** 15-26 hours

## Success Criteria

- ✅ App builds without errors on iOS
- ✅ Core Emby functionality works (browse, search, play)
- ✅ Video playback functions properly
- ✅ State management and navigation work
- ✅ Local database operations function
- ✅ Settings and preferences persist
- ⚠️ External player integration (iOS alternatives)
- ⚠️ Some Android-specific optimizations may be lost

## Risk Assessment

**Low Risk:**
- Core Flutter/Dart functionality
- Media Kit video playback
- Riverpod state management
- Network requests and caching

**Medium Risk:**
- iOS-specific Media Kit configuration
- External player integration changes
- Platform UI differences

**High Risk:**
- App Store approval process
- iOS device testing requirements
- Code signing complexity

## Conclusion

The Themby app can be successfully ported to iOS with moderate effort. The core architecture is well-designed for cross-platform compatibility. Most challenges involve replacing Android-specific features with iOS equivalents and ensuring proper iOS configuration for Media Kit video playback.