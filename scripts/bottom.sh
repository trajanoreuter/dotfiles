#!/bin/sh
# Install bottom (btm) — system monitor
# https://github.com/ClementTsang/bottom

set -e
VERSION=$(curl -sL https://api.github.com/repos/ClementTsang/bottom/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
ARCH=$(uname -m)
case "$ARCH" in
  x86_64) ARCH="x86_64" ;;
  aarch64|arm64) ARCH="aarch64" ;;
esac
curl -sL "https://github.com/ClementTsang/bottom/releases/download/${VERSION}/bottom_${ARCH}-unknown-linux-musl.tar.gz" -o /tmp/bottom.tar.gz
tar -xzf /tmp/bottom.tar.gz -C /tmp btm
sudo mv /tmp/btm /usr/local/bin/btm
sudo chmod +x /usr/local/bin/btm
rm -f /tmp/bottom.tar.gz
echo "bottom installed: $(btm --version)"
