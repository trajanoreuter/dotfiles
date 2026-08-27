#!/bin/sh
# Install herdr — agent-aware terminal multiplexer (tmux replacement)
# https://github.com/herdrdev/herdr

set -e
VERSION=$(curl -sL https://api.github.com/repos/herdrdev/herdr/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
ARCH=$(uname -m)
case "$ARCH" in
  x86_64) ARCH="x86_64" ;;
  aarch64|arm64) ARCH="aarch64" ;;
esac
curl -sL "https://github.com/herdrdev/herdr/releases/download/${VERSION}/herdr-linux-${ARCH}" -o /tmp/herdr
sudo mv /tmp/herdr /usr/local/bin/herdr
sudo chmod +x /usr/local/bin/herdr
echo "herdr installed: $(herdr --version)"
