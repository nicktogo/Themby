# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Essential Flutter Commands
```bash
flutter run                    # Run in debug mode
flutter build apk             # Build Android APK
flutter build appbundle       # Build Android App Bundle
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
- **Player**: Media Kit with MPV backend (Android-focused)
- **Networking**: Dio with `dio_cache_interceptor` for API caching
- **Images**: `cached_network_image` with custom network layer
- **Emby Integration**: Domain models with JSON serialization

### UI/Theme System
- Material 3 with dynamic color schemes
- Custom color selection via `colorType` array
- Theme mode support (light/dark/system)
- Custom dialog system replacing default Flutter dialogs
- Android-specific UI optimizations (edge-to-edge, high refresh rate)

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

### Android Focus
- Primary target platform with optimizations:
  - High refresh rate display support
  - Edge-to-edge UI with transparent system bars
  - Hardware acceleration for video playback
  - Custom splash screen configuration

### Dependencies Note
- Uses specific versions of media_kit libraries for stability
- ObjectBox requires platform-specific setup
- Some packages have Android-only functionality

## Code Generation Workflow
1. Modify provider/entity/serializable class
2. Run `flutter packages pub run build_runner build --delete-conflicting-outputs`
3. Check generated `.g.dart` files are created/updated
4. Run `flutter analyze` to verify no issues
5. Test functionality before committing

Always run code generation before building or testing when provider/entity changes are made.