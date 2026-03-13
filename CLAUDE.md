# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Clash Mi is a multi-platform VPN proxy application built with Flutter/Dart, using the Mihomo (Clash.Meta) core. It supports iOS, macOS, Android, Windows, and Linux.

**Key characteristics:**
- Flutter app with native platform integrations (Android/Kotlin, iOS/Swift)
- Embeds Mihomo VPN core via native FFI and services
- Uses Provider pattern for state management
- Manager pattern for core services (ProfileManager, ClashSettingManager, SettingManager, etc.)
- Multi-language support via slang i18n system
- Embedded zashboard web dashboard for proxy management

## Development Commands

### Running the App
```bash
# Run on connected device/simulator
flutter run

# Run on specific device
flutter run -d <device-id>

# Run in release mode
flutter run --release
```

### Building
```bash
# Build for Android
flutter build apk
flutter build appbundle

# Build for iOS
flutter build ios

# Build for macOS
flutter build macos

# Build for Windows
flutter build windows

# Build for Linux (default: x64)
flutter build linux

# Build for Linux ARM architectures
flutter build linux --target-platform linux-arm64  # ARM64
flutter build linux --target-platform linux-arm    # ARMv7
```

### Building Release Packages (DEB/RPM)

The project uses `flutter_distributor` for creating release packages:

```bash
# Install flutter_distributor
flutter pub global activate flutter_distributor

# Build all Linux ARM packages (DEB and RPM for arm64 and armv7)
./build_linux_arm.sh

# Build specific architecture and format
./build_linux_arm.sh "arm64" "deb"     # Only ARM64 DEB
./build_linux_arm.sh "armv7" "rpm"     # Only ARMv7 RPM
./build_linux_arm.sh "arm64 armv7" "deb"  # Both ARM architectures, DEB only

# Build individual package with flutter_distributor
flutter_distributor release --name release --jobs linux-deb-arm64
flutter_distributor release --name release --jobs linux-rpm-armv7
```

**Note**: ARM builds require cross-compilation toolchains:
- For ARM64: `gcc-aarch64-linux-gnu`, `g++-aarch64-linux-gnu`
- For ARMv7: `gcc-arm-linux-gnueabihf`, `g++-arm-linux-gnueabihf`

### Code Generation
```bash
# Generate JSON serialization code (for @JsonSerializable classes)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for continuous generation
dart run build_runner watch --delete-conflicting-outputs

# Generate translation files (slang)
flutter pub run slang
```

### Testing and Analysis
```bash
# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format lib/ test/
```

### Dependencies
```bash
# Get dependencies
flutter pub get

# Upgrade dependencies
flutter pub upgrade

# Clean build artifacts
flutter clean
```

## Architecture

### Directory Structure

- **`lib/main.dart`** - Application entry point with initialization sequence and platform-specific setup
- **`lib/app/modules/`** - Core business logic managers
  - `biz.dart` - Central initialization/shutdown coordinator
  - `profile_manager.dart` - VPN profile management
  - `clash_setting_manager.dart` - Clash core configuration
  - `setting_manager.dart` - App settings and preferences
  - `auto_update_manager.dart` - Update checking and installation
  - `remote_config_manager.dart` - Remote configuration sync
  - `zashboard.dart` - Web dashboard integration
- **`lib/app/local_services/`** - Platform-native services
  - `vpn_service.dart` - VPN connection management via native bridge
- **`lib/app/clash/`** - Clash/Mihomo integration
  - `clash_config.dart` - Configuration models
  - `clash_http_api.dart` - HTTP API client for Clash core
- **`lib/screens/`** - UI layer (screens, widgets, dialogs)
- **`lib/app/utils/`** - Utility functions (file, network, crypto, platform-specific)
- **`lib/i18n/`** - Internationalization (slang-generated files, JSON sources)
- **`android/`** - Android native code (Kotlin)
  - `libclash/` - Mihomo core AAR library
  - `app/src/main/kotlin/com/nebula/clashmi/` - Native service implementations
- **`ios/`** - iOS native code (Swift)
- **`assets/`** - Static assets (images, fonts, embedded dashboard, geodata)

### Initialization Flow

The app initialization follows this sequence (see `lib/main.dart` and `lib/app/modules/biz.dart`):

1. `LocaleSettings.useDeviceLocale()` - Initialize i18n
2. `VPNService.initABI()` - Load native VPN service
3. `RemoteConfigManager.init()` - Load remote configuration
4. `SettingManager.init()` - Load app settings
5. Platform-specific checks (version, installation path, permissions)
6. Window manager setup (desktop platforms)
7. `Biz.init()` - Initialize core services:
   - ClashSettingManager
   - ProfileManager
   - ProfilePatchManager
   - DiversionTemplateManager
   - VPNService

### State Management

- Uses `provider` package with `ChangeNotifierProvider`
- `Themes` class manages theme state
- Managers expose state through static methods and callbacks
- Event-driven architecture for VPN state changes, lifecycle events

### Native Integrations

**Android:**
- VPN service implemented in `TileService.kt` and `MainActivity.kt`
- Mihomo core bundled as AAR in `android/libclash/`
- Uses `libclash_vpn_service` plugin for FFI bridge

**iOS:**
- Network extension for VPN functionality
- Widget extension (`clashmiWidget/`) for home screen controls
- iCloud integration for backup/sync

**Desktop (Windows/macOS/Linux):**
- System tray integration via `tray_manager`
- Window management via custom `window_manager` fork
- Launch at startup support
- Protocol handler for `clashmi://` URLs

## Key Technical Notes

### JSON Serialization
Classes with `@JsonSerializable` annotations require code generation. After modifying these classes, run:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Internationalization
- Source files: `lib/i18n/*.i18n.json`
- Generated files: `lib/i18n/strings*.g.dart`
- Uses slang for type-safe i18n
- Access translations via `t.<category>.<key>` (e.g., `t.meta.connect`)

### Custom Forks
The project uses custom forks of some packages:
- `flutter_inappwebview` - For embedded web dashboard
- `window_manager` - Desktop window management
- `android_package_manager` - Android app management
- `move_to_background` - Android background handling

These are referenced via git dependencies in `pubspec.yaml`.

### VPN Service Dependency
`libclash_vpn_service` is a local path dependency (expects `../libclash-vpn-service/`). This wraps the Mihomo core and provides the VPN implementation.

### Platform-Specific Code Paths
The codebase extensively uses `Platform.isX` checks and `PlatformUtils.isPC()/isMobile()` for conditional behavior. Key differences:
- Desktop: tray icon, window management, system integration
- Mobile: VPN profiles, network extension, gesture navigation
- Each platform has distinct build configurations and permissions

## Common Workflows

### Adding a New Screen
1. Create screen file in `lib/screens/`
2. Add route in `lib/screens/widgets/routes.dart`
3. Use `Navigator.push()` with appropriate screen widget
4. Screens typically extend `StatefulWidget` and use `Scaffold`

### Adding a New Setting
1. Update model in `lib/app/modules/setting_manager.dart`
2. Add UI control in relevant settings screen
3. Persist via `SettingManager.getConfig()` and `SettingManager.setDirty()`
4. If needs JSON serialization, run build_runner

### Modifying Clash Configuration
1. Update models in `lib/app/clash/clash_config.dart`
2. Modify `ClashSettingManager` logic as needed
3. Configuration is YAML-based; app generates config from profiles + patches
4. Changes require VPN restart to take effect

### Adding Translations
1. Add keys to all `lib/i18n/*.i18n.json` files
2. Run `flutter pub run slang` to regenerate
3. Use via `t.<key>` in UI code
4. English (`en.i18n.json`) is the base language

## Build Configuration

- **Version**: Managed in `pubspec.yaml` (currently 1.0.19+502)
- **SDK constraints**: Dart >=3.9.0, Flutter >=3.35.0
- **Minimum platforms**: Android 8+, iOS 15+, macOS 12+, Windows 10+, Linux (x64, ARM64, ARMv7)
- **Release signing**: Android keys in `android/key.properties` (gitignored)

### Supported Linux Architectures
- **x86_64 (amd64)**: Standard desktop/laptop architecture
- **ARM64 (aarch64)**: Raspberry Pi 3/4/5 (64-bit), ARM servers, Apple Silicon via Rosetta
- **ARMv7 (armhf)**: Raspberry Pi 2/3 (32-bit), older ARM devices

All architectures support both DEB and RPM package formats. Release configurations are in `distribute_options.yaml`.
