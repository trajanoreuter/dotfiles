#!/bin/sh
# Install nushell (nu) — modern shell
# https://github.com/nushell/nushell

set -e
VERSION=$(curl -sL https://api.github.com/repos/nushell/nushell/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
ARCH=$(uname -m)
case "$ARCH" in
  x86_64) ARCH="x86_64" ;;
  aarch64|arm64) ARCH="aarch64" ;;
esac
curl -sL "https://github.com/nushell/nushell/releases/download/${VERSION}/nu-${VERSION}-${ARCH}-unknown-linux-musl.tar.gz" -o /tmp/nu.tar.gz
tar -xzf /tmp/nu.tar.gz -C /tmp
sudo mv "/tmp/nu-${VERSION}-${ARCH}-unknown-linux-musl/nu" /usr/local/bin/nu
sudo chmod +x /usr/local/bin/nu
rm -rf /tmp/nu.tar.gz /tmp/nu-*
echo "nushell installed: $(nu --version)"
