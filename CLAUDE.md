# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Essential Flutter Commands
```bash
flutter run                    # Run in debug mode
flutter build ios --release   # Build iOS release (primary platform)
flutter build ipa             # Build iOS app archive
flutter analyze               # Static analysis
flutter pub get               # Install dependencies
flutter clean && flutter pub get  # Clean rebuild dependencies
```

### Code Generation (Critical)
This project heavily uses code generation. Run these commands after modifying:
- Riverpod providers (files with `@riverpod`)
- ObjectBox entities
- JSON serializable classes

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
flutter packages pub run build_runner watch  # Watch mode for development
```

### Internationalization
```bash
flutter gen-l10n              # Generate localization files
```

## Architecture Overview

### State Management - Riverpod with Code Generation
- Uses `flutter_riverpod` with `riverpod_generator` for automatic provider generation
- Providers are annotated with `@riverpod` and generate `.g.dart` files
- Key state services:
  - `EmbyStateService` - Manages Emby connection state and authentication
  - `AppSettingRepository` - Handles app-wide settings (theme, player config)
  - Feature-specific repositories in each domain

### Feature-Based Structure
```
lib/src/features/
├── emby/           # Emby media server integration
├── player/         # Video player functionality
├── mine/           # User settings and preferences
└── home/           # Main navigation hub
```

### Database Layer - ObjectBox
- Local storage using ObjectBox with code generation
- Entities generate `.g.dart` files automatically
- Store initialization in `main.dart` with dependency injection
- Key entities: favorites, play history, cache data

### Navigation - GoRouter
- Nested navigation structure using `StatefulShellRoute.indexedStack`
- Main shell navigation between Emby content and favorites
- Deep linking support for media details and player screens
- Custom transition animations for different route types

### Media Architecture
- **Player**: Media Kit with MPV backend
- **Networking**: Dio with `dio_cache_interceptor` for API caching
- **Images**: `cached_network_image` with custom network layer
- **Emby Integration**: Domain models with JSON serialization

### UI/Theme System
- **Primary Platform**: iOS with Cupertino design language
- **Design System**: Cupertino widgets (CupertinoApp, CupertinoNavigationBar, CupertinoButton, etc.)
- **Navigation**: CupertinoTabScaffold for bottom tab navigation
- **Dialogs**: CupertinoAlertDialog and CupertinoActionSheet for native iOS feel
- **Theme Support**: Light/dark mode with CupertinoThemeData
- **Transitions**: Native iOS page transitions and gestures (swipe-to-go-back)

## Key Development Patterns

### Riverpod Provider Structure
```dart
@riverpod
class FeatureService extends _$FeatureService {
  @override
  ModelType build() {
    // Initialize state
  }
}
```

### Repository Pattern
- Data repositories handle API calls and caching
- Services orchestrate business logic
- Domain models are separate from API response models

### Error Handling
- Uses `flutter_smart_dialog` for user-facing messages
- Custom dialog widgets for consistent UX
- Network error handling in repositories

## Platform Specifics

### iOS Focus (Primary Platform)
- Native iOS design with Cupertino widgets
- iOS-specific optimizations:
  - Swipe-to-go-back navigation gestures
  - Native iOS status bar handling
  - CupertinoTabBar for bottom navigation
  - CupertinoNavigationBar with iOS-style transitions
  - Preferred frame rates for smooth video playback
  - iOS-native dialogs and action sheets

### Widget Migration Guide
When working with UI code, follow these Cupertino equivalents:
- `Scaffold` → `CupertinoPageScaffold`
- `AppBar` → `CupertinoNavigationBar`
- `FloatingActionButton` → `CupertinoButton.filled`
- `ElevatedButton/TextButton` → `CupertinoButton`
- `AlertDialog` → `CupertinoAlertDialog`
- `PopupMenuButton` → `CupertinoActionSheet`
- `NavigationBar` → `CupertinoTabBar`
- `RefreshIndicator` → `CupertinoSliverRefreshControl`
- Material Icons → `CupertinoIcons`

### Dependencies Note
- Uses specific versions of media_kit libraries for stability
- ObjectBox requires platform-specific setup
- flutter_smart_dialog adapted for Cupertino design

## Code Generation Workflow
1. Modify provider/entity/serializable class
2. Run `flutter packages pub run build_runner build --delete-conflicting-outputs`
3. Check generated `.g.dart` files are created/updated
4. Run `flutter analyze` to verify no issues
5. Test functionality before committing

Always run code generation before building or testing when provider/entity changes are made.