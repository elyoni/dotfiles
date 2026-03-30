#!/usr/bin/env bash
# Build Ghostty from source inside Docker and install the result on the host.
#
# Usage:
#   ./build.sh [version] [install_prefix]
#
# Defaults:
#   version        1.3.1
#   install_prefix /usr/local

set -euo pipefail

GHOSTTY_VERSION="${1:-1.3.1}"
INSTALL_PREFIX="${2:-/usr/local}"
IMAGE_NAME="ghostty-builder:${GHOSTTY_VERSION}"
BUILD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP_OUT=$(mktemp -d)

cleanup() { rm -rf "$TMP_OUT"; }
trap cleanup EXIT

echo "==> Building Ghostty ${GHOSTTY_VERSION} (this will take a while)..."
docker build \
    --build-arg GHOSTTY_VERSION="$GHOSTTY_VERSION" \
    -t "$IMAGE_NAME" \
    "$BUILD_DIR"

echo "==> Extracting build artifacts..."
container_id=$(docker create "$IMAGE_NAME")
docker cp "${container_id}:/build/zig-out/." "$TMP_OUT"
docker rm "$container_id" > /dev/null

echo "==> Installing to ${INSTALL_PREFIX}..."

# gtk4-layer-shell shared libs (built inside Docker, not packaged on Ubuntu 24.04)
if ls "$TMP_OUT/lib/libgtk4-layer-shell"* &>/dev/null; then
    sudo cp -P "$TMP_OUT"/lib/libgtk4-layer-shell* /usr/local/lib/
    sudo ldconfig
fi

# Binary
sudo install -Dm755 "$TMP_OUT/bin/ghostty" "${INSTALL_PREFIX}/bin/ghostty"

# Desktop entry
if [[ -f "$TMP_OUT/share/applications/com.mitchellh.ghostty.desktop" ]]; then
    sudo install -Dm644 \
        "$TMP_OUT/share/applications/com.mitchellh.ghostty.desktop" \
        "${INSTALL_PREFIX}/share/applications/com.mitchellh.ghostty.desktop"
fi

# Icons
[[ -d "$TMP_OUT/share/icons" ]] && sudo cp -r "$TMP_OUT/share/icons" "${INSTALL_PREFIX}/share/"

# Terminfo
[[ -d "$TMP_OUT/share/terminfo" ]] && sudo cp -r "$TMP_OUT/share/terminfo" "${INSTALL_PREFIX}/share/"

# Shell completions
for dir in bash zsh fish; do
    src="$TMP_OUT/share/bash-completion/completions"
    [[ "$dir" == "zsh" ]] && src="$TMP_OUT/share/zsh/site-functions"
    [[ "$dir" == "fish" ]] && src="$TMP_OUT/share/fish/vendor_completions.d"
    [[ -d "$src" ]] && sudo cp -r "$src" "${INSTALL_PREFIX}/share/${dir}/" 2>/dev/null || true
done

# Refresh desktop database
command -v update-desktop-database &>/dev/null \
    && sudo update-desktop-database "${INSTALL_PREFIX}/share/applications" || true

echo ""
echo "Done! Ghostty ${GHOSTTY_VERSION} installed to ${INSTALL_PREFIX}/bin/ghostty"
