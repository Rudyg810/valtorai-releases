#!/usr/bin/env bash

set -e

REPO="Rudyg810/valtorai-releases"
BASE_URL="https://github.com/$REPO/releases/latest/download"

OS="$(uname | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

# Normalize architecture
case "$ARCH" in
  x86_64) ARCH="amd64" ;;
  arm64|aarch64) ARCH="arm64" ;;
  *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

# Normalize OS
case "$OS" in
  darwin) OS="darwin" ;;
  linux) OS="linux" ;;
  *) echo "Unsupported OS: $OS"; exit 1 ;;
esac

ASSET="valtor-${OS}-${ARCH}.tar.gz"
BINARY_NAME="valtor-${OS}-${ARCH}"
URL="$BASE_URL/$ASSET"

INSTALL_DIR="/usr/local/bin"
TMP_DIR="$(mktemp -d)"

echo "Downloading $ASSET..."
curl -fsSL "$URL" -o "$TMP_DIR/$ASSET"

echo "Extracting..."
tar -xzf "$TMP_DIR/$ASSET" -C "$TMP_DIR"

# Find binary (handles nested dirs)
BIN_PATH="$(find "$TMP_DIR" -type f -name "$BINARY_NAME" | head -n 1)"

if [ -z "$BIN_PATH" ]; then
  echo "Binary $BINARY_NAME not found in archive"
  exit 1
fi

echo "Installing to $INSTALL_DIR (sudo required)..."
sudo mv "$BIN_PATH" "$INSTALL_DIR/valtor"
sudo chmod +x "$INSTALL_DIR/valtor"

# macOS quarantine fix
xattr -d com.apple.quarantine "$INSTALL_DIR/valtor" 2>/dev/null || true

rm -rf "$TMP_DIR"

echo "Running valtor init..."
valtor init || true

echo "Installation complete."