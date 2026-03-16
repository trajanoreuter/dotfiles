#!/bin/sh
# Install wtfutil — personal terminal dashboard
# https://github.com/wtfutil/wtf

set -e
VERSION=$(curl -sL https://api.github.com/repos/wtfutil/wtf/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
curl -sL "https://github.com/wtfutil/wtf/releases/download/${VERSION}/wtf_${VERSION#v}_linux_amd64.tar.gz" -o /tmp/wtf.tar.gz
# Archive may extract flat or into a subdirectory — handle both
mkdir -p /tmp/wtf-extract
tar -xzf /tmp/wtf.tar.gz -C /tmp/wtf-extract
WTF_BIN=$(find /tmp/wtf-extract -name wtfutil -type f | head -1)
if [ -z "$WTF_BIN" ]; then
  echo "Error: wtfutil binary not found in archive" >&2
  exit 1
fi
sudo mv "$WTF_BIN" /usr/local/bin/wtfutil
sudo chmod +x /usr/local/bin/wtfutil
rm -rf /tmp/wtf.tar.gz /tmp/wtf-extract
echo "wtfutil installed: $(wtfutil --version)"
