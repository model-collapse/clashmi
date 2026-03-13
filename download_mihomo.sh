#!/bin/bash
set -e

MIHOMO_VERSION="v1.19.21"
DOWNLOAD_DIR="bind/linux/core"

mkdir -p "$DOWNLOAD_DIR"

# Detect architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        MIHOMO_ARCH="amd64"
        OUTPUT_NAME="clashmiService"
        ;;
    aarch64)
        MIHOMO_ARCH="arm64"
        OUTPUT_NAME="clashmiService"
        ;;
    armv7l)
        MIHOMO_ARCH="armv7"
        OUTPUT_NAME="clashmiService"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

DOWNLOAD_URL="https://github.com/MetaCubeX/mihomo/releases/download/${MIHOMO_VERSION}/mihomo-linux-${MIHOMO_ARCH}-${MIHOMO_VERSION}.gz"
OUTPUT_PATH="${DOWNLOAD_DIR}/${OUTPUT_NAME}"

echo "Downloading Mihomo ${MIHOMO_VERSION} for ${MIHOMO_ARCH}..."
echo "URL: ${DOWNLOAD_URL}"

# Download and extract
curl -L "$DOWNLOAD_URL" -o "/tmp/mihomo.gz"
gunzip -c "/tmp/mihomo.gz" > "$OUTPUT_PATH"
chmod +x "$OUTPUT_PATH"
rm "/tmp/mihomo.gz"

echo "Mihomo binary downloaded to: ${OUTPUT_PATH}"
ls -lh "$OUTPUT_PATH"
