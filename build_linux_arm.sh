#!/bin/bash
# Build script for Linux ARM architectures
# This script builds Clash Mi for armv7, arm64 architectures

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Clash Mi Linux ARM Build Script ===${NC}"
echo ""

# Check if flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}Error: Flutter is not installed or not in PATH${NC}"
    echo "Please install Flutter: https://docs.flutter.dev/get-started/install/linux"
    exit 1
fi

# Check if flutter_distributor is installed
if ! flutter pub global list | grep -q flutter_distributor; then
    echo -e "${YELLOW}Installing flutter_distributor...${NC}"
    flutter pub global activate flutter_distributor
fi

# Ensure dependencies are installed
echo -e "${YELLOW}Getting Flutter dependencies...${NC}"
flutter pub get

# Build architectures
ARCHS=${1:-"arm64 armv7"}
FORMATS=${2:-"deb rpm"}

echo -e "${GREEN}Building for architectures: $ARCHS${NC}"
echo -e "${GREEN}Building formats: $FORMATS${NC}"
echo ""

for ARCH in $ARCHS; do
    for FORMAT in $FORMATS; do
        echo -e "${GREEN}========================================${NC}"
        echo -e "${GREEN}Building Linux $FORMAT for $ARCH${NC}"
        echo -e "${GREEN}========================================${NC}"

        JOB_NAME="linux-${FORMAT}-${ARCH}"

        if [ "$ARCH" = "amd64" ]; then
            # For amd64, no special target-platform needed
            flutter_distributor release --name release --jobs "$JOB_NAME"
        else
            # For ARM architectures
            flutter_distributor release --name release --jobs "$JOB_NAME"
        fi

        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Successfully built $FORMAT for $ARCH${NC}"
        else
            echo -e "${RED}✗ Failed to build $FORMAT for $ARCH${NC}"
            exit 1
        fi
        echo ""
    done
done

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}All builds completed successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "${YELLOW}Output directory: dist/${NC}"
ls -lh dist/ | tail -n +2
