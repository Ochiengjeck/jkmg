# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

JKMG is a Flutter-based spiritual ministry mobile application targeting Android, iOS, Web, and Windows. It provides features for prayer tracking, Bible studies, event management, donations, counseling, and more.

## Build Commands

```bash
# Install dependencies
flutter pub get

# Run the app (debug mode)
flutter run

# Build release APK
flutter build apk --release

# Build debug APK (faster, for testing)
flutter build apk --debug

# Run linting/analysis
flutter analyze

# Run tests
flutter test

# Clean build artifacts
flutter clean
```

**APK output location:** `build/app/outputs/flutter-apk/app-release.apk`

**Known build issue:** Minification is currently disabled due to file locking issues on Windows. See `BUILD_FIX_INSTRUCTIONS.md` for details.

## Architecture

### State Management: Riverpod

The app uses Flutter Riverpod for state management with this pattern:

- **`lib/provider/providers.dart`** - Core providers (ApiService, theme, Bible service)
- **`lib/provider/api_providers.dart`** - Domain-specific FutureProviders for API calls
- **`lib/provider/theme_notifier.dart`** - Theme state management

Provider types used:
- `Provider` for singleton services
- `FutureProvider` for async API calls with automatic caching
- `FutureProvider.family` for parameterized API calls
- `StateNotifierProvider` for stateful management (theme, auth)

### Service Layer

Located in `lib/services/`:

- **`api_service.dart`** - Centralized REST API client with Bearer token auth (Laravel Sanctum)
- **`bible_service.dart`** - External Bible API integration (bible.helloao.org)
- **`preference_service.dart`** - SharedPreferences wrapper for local storage
- **`alarm_service.dart`** - Notification scheduling for prayer reminders
- **`chat_database_service.dart`** - SQLite database for chat/messaging

### Data Flow

```
UI (Screens) → Riverpod Providers → Services → API/Storage
                    ↓
              Automatic caching & reactivity
```

### Key Files

- **`lib/main.dart`** - Entry point, initializes MediaKit, sqflite, timezone
- **`lib/widgets/app_initializer.dart`** - Splash screen and auth routing logic
- **`lib/utils/app_theme.dart`** - Black & Gold color scheme (AppTheme class)
- **`.env`** - Contains `BASE_URL` for API endpoint

### Authentication Flow

1. Login/Register returns Bearer token from Laravel Sanctum backend
2. Token stored via `PreferenceService` (SharedPreferences)
3. `AppInitializer` widget checks auth state on app start
4. `ApiService` auto-includes Bearer token in requests
5. 401 responses trigger automatic logout

## API Documentation

Complete API documentation is in `docs/ApiDocumentation.md`. The backend uses Laravel Sanctum authentication. Key endpoint categories:
- Authentication (`/login`, `/register`, `/logout`)
- Prayer system (`/prayers/schedule`, `/prayers/request`)
- Bible studies (`/bible/today`, `/bible/studies`)
- Events (`/events`, `/events/register`)
- Donations (`/donate`)
- Counseling (`/counseling/book`)

## Platform-Specific Notes

- **Windows/Desktop:** Uses `sqfliteFfiInit()` for SQLite FFI bindings
- **Android:** Package name is `com.jkmg.app`
- **Timezone:** Uses `timezone` package for prayer notification scheduling

## Environment Configuration

The `.env` file must contain:
```
BASE_URL=https://jkmg.org/api
```
