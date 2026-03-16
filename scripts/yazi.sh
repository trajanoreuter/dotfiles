#!/bin/sh
# Install yazi — terminal file manager
# https://github.com/sxyazi/yazi

set -e
VERSION=$(curl -sL https://api.github.com/repos/sxyazi/yazi/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
ARCH=$(uname -m)
case "$ARCH" in
  x86_64) ARCH="x86_64" ;;
  aarch64|arm64) ARCH="aarch64" ;;
esac
curl -sL "https://github.com/sxyazi/yazi/releases/download/${VERSION}/yazi-${ARCH}-unknown-linux-musl.zip" -o /tmp/yazi.zip
unzip -o /tmp/yazi.zip -d /tmp/yazi-extract
sudo mv "/tmp/yazi-extract/yazi-${ARCH}-unknown-linux-musl/yazi" /usr/local/bin/yazi
sudo chmod +x /usr/local/bin/yazi
rm -rf /tmp/yazi.zip /tmp/yazi-extract
echo "yazi installed: $(yazi --version)"
