#!/bin/sh
# Install k9s — Kubernetes TUI
# https://github.com/derailed/k9s

set -e
VERSION=$(curl -sL https://api.github.com/repos/derailed/k9s/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
ARCH=$(uname -m)
case "$ARCH" in
  x86_64) ARCH="amd64" ;;
  aarch64|arm64) ARCH="arm64" ;;
esac
curl -sL "https://github.com/derailed/k9s/releases/download/${VERSION}/k9s_Linux_${ARCH}.tar.gz" -o /tmp/k9s.tar.gz
tar -xzf /tmp/k9s.tar.gz -C /tmp k9s
sudo mv /tmp/k9s /usr/local/bin/k9s
sudo chmod +x /usr/local/bin/k9s
rm -f /tmp/k9s.tar.gz
echo "k9s installed: $(k9s version --short 2>/dev/null | head -1)"
