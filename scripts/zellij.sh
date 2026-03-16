#!/bin/sh
# Install zellij — terminal multiplexer
# https://github.com/zellij-org/zellij

set -e
VERSION=$(curl -sL https://api.github.com/repos/zellij-org/zellij/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
ARCH=$(uname -m)
case "$ARCH" in
  x86_64) ARCH="x86_64" ;;
  aarch64|arm64) ARCH="aarch64" ;;
esac
curl -sL "https://github.com/zellij-org/zellij/releases/download/${VERSION}/zellij-${ARCH}-unknown-linux-musl.tar.gz" -o /tmp/zellij.tar.gz
tar -xzf /tmp/zellij.tar.gz -C /tmp zellij
sudo mv /tmp/zellij /usr/local/bin/zellij
sudo chmod +x /usr/local/bin/zellij
rm -f /tmp/zellij.tar.gz
echo "zellij installed: $(zellij --version)"
