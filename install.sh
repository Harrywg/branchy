#!/usr/bin/env sh
set -e

REPO="Harrywg/branchy"
BIN_DIR="/usr/local/bin"
BIN_NAME="branchy"

# Detect OS and pick the correct asset name
case "$(uname -s)" in
  Darwin) ASSET="branchy_macos" ;;
  Linux)  ASSET="branchy_linux" ;;
  *)
    echo "Error: unsupported OS '$(uname -s)'. Supported platforms: macOS, Linux." >&2
    exit 1
    ;;
esac

# Resolve the latest release download URL
DOWNLOAD_URL="https://github.com/${REPO}/releases/download/v0.1.0-demo/${ASSET}"

echo "Downloading ${ASSET}..."
if command -v curl > /dev/null 2>&1; then
  curl -fsSL "$DOWNLOAD_URL" -o "/tmp/${ASSET}"
elif command -v wget > /dev/null 2>&1; then
  wget -q "$DOWNLOAD_URL" -O "/tmp/${ASSET}"
else
  echo "Error: curl or wget is required." >&2
  exit 1
fi

chmod +x "/tmp/${ASSET}"

# Install — try without sudo first, fall back if needed
if [ -w "$BIN_DIR" ]; then
  mv "/tmp/${ASSET}" "${BIN_DIR}/${BIN_NAME}"
else
  echo "Requires sudo to install to ${BIN_DIR}..."
  sudo mv "/tmp/${ASSET}" "${BIN_DIR}/${BIN_NAME}"
fi

echo "Installed branchy to ${BIN_DIR}/${BIN_NAME}"
