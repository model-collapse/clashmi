# Building Clash Mi for ARM Architectures

This guide explains how to build Clash Mi for ARM-based Linux systems (Raspberry Pi, ARM servers, etc.).

## Supported ARM Architectures

| Architecture | Description | Example Devices |
|-------------|-------------|-----------------|
| **ARM64 (aarch64)** | 64-bit ARM | Raspberry Pi 3/4/5 (64-bit OS), ARM servers, NVIDIA Jetson |
| **ARMv7 (armhf)** | 32-bit ARM with hardware float | Raspberry Pi 2/3 (32-bit OS), older ARM devices |

## Prerequisites

### 1. Install Flutter

Follow the official Flutter installation guide for Linux:
https://docs.flutter.dev/get-started/install/linux

```bash
# Verify Flutter installation
flutter --version
```

### 2. Install Cross-Compilation Toolchains

For building ARM binaries on x86_64 systems:

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y \
  gcc-aarch64-linux-gnu \
  g++-aarch64-linux-gnu \
  gcc-arm-linux-gnueabihf \
  g++-arm-linux-gnueabihf

# Additional dependencies for Linux builds
sudo apt-get install -y \
  clang \
  cmake \
  ninja-build \
  pkg-config \
  libgtk-3-dev \
  libayatana-appindicator3-dev \
  libkeybinder-3.0-dev \
  libsecret-1-dev \
  rpm
```

### 3. Install Flutter Distributor

```bash
flutter pub global activate flutter_distributor
export PATH="$PATH:$HOME/.pub-cache/bin"
```

### 4. Get Project Dependencies

```bash
cd clashmi
flutter pub get
```

## Building

### Quick Build (All ARM Architectures)

Use the provided build script to build all ARM packages:

```bash
./build_linux_arm.sh
```

This will create:
- DEB packages for ARM64 and ARMv7
- RPM packages for ARM64 and ARMv7

### Build Specific Architecture

```bash
# Build only ARM64 packages
./build_linux_arm.sh "arm64" "deb rpm"

# Build only ARMv7 packages
./build_linux_arm.sh "armv7" "deb rpm"

# Build only DEB packages for all ARM architectures
./build_linux_arm.sh "arm64 armv7" "deb"
```

### Manual Build with Flutter Distributor

```bash
# ARM64 DEB
flutter_distributor release --name release --jobs linux-deb-arm64

# ARM64 RPM
flutter_distributor release --name release --jobs linux-rpm-arm64

# ARMv7 DEB
flutter_distributor release --name release --jobs linux-deb-armv7

# ARMv7 RPM
flutter_distributor release --name release --jobs linux-rpm-armv7
```

### Direct Flutter Build (No Package)

For testing without creating packages:

```bash
# ARM64
flutter build linux --target-platform linux-arm64 --release

# ARMv7
flutter build linux --target-platform linux-arm --release
```

## Output

Built packages are located in the `dist/` directory:

```
dist/
├── <version>/
│   ├── clashmi-<version>-linux-arm64.deb
│   ├── clashmi-<version>-linux-arm64.rpm
│   ├── clashmi-<version>-linux-armv7.deb
│   └── clashmi-<version>-linux-armv7.rpm
```

## Native Binary Requirements

⚠️ **Important**: The Mihomo core binary (`clashmiService`) must match the target architecture.

The CMakeLists.txt expects the core binary at:
```
../bind/linux/core/clashmiService
```

Ensure you have the correct ARM version of this binary for your target architecture:
- ARM64: `clashmiService` compiled for aarch64
- ARMv7: `clashmiService` compiled for armhf

You can obtain ARM binaries from:
- [Mihomo releases](https://github.com/MetaCubeX/mihomo/releases) - Download `mihomo-linux-arm64` or `mihomo-linux-armv7`
- Build from source using Go cross-compilation

## Testing on ARM Devices

### Raspberry Pi

1. Transfer the DEB package to your Raspberry Pi:
   ```bash
   scp dist/*/clashmi-*-linux-arm64.deb pi@raspberrypi:~
   ```

2. Install on the device:
   ```bash
   sudo dpkg -i clashmi-*-linux-arm64.deb
   sudo apt-get install -f  # Fix any missing dependencies
   ```

3. Run:
   ```bash
   clashmi
   ```

## Automated Builds (GitHub Actions)

The repository includes a GitHub Actions workflow (`.github/workflows/build-linux-arm.yml`) that automatically builds ARM packages:

- **Trigger**: Push tags matching `v*` or manual workflow dispatch
- **Outputs**: DEB and RPM packages for ARM64 and ARMv7
- **Release**: Automatically creates GitHub releases with ARM packages

To trigger a manual build:
1. Go to Actions tab in GitHub
2. Select "Build Linux ARM" workflow
3. Click "Run workflow"

## Troubleshooting

### Missing Cross-Compilation Toolchains

**Error**: `Could not find aarch64-linux-gnu-gcc`

**Solution**: Install the cross-compilation toolchains as described in Prerequisites.

### Flutter Engine Not Available for ARM

**Error**: Flutter engine not available for the target architecture

**Solution**: Ensure you're using Flutter 3.35.0 or later, which includes ARM Linux support.

### Native Binary Architecture Mismatch

**Error**: App crashes or fails to start the VPN service

**Solution**: Verify that `clashmiService` binary matches your target architecture:
```bash
file bind/linux/core/clashmiService
```

Should output:
- ARM64: `ELF 64-bit LSB executable, ARM aarch64`
- ARMv7: `ELF 32-bit LSB executable, ARM, EABI5`

## Additional Resources

- [Flutter Linux Desktop](https://docs.flutter.dev/platform-integration/linux/building)
- [Mihomo GitHub](https://github.com/MetaCubeX/mihomo)
- [Cross-compilation Guide](https://wiki.debian.org/CrossCompiling)
