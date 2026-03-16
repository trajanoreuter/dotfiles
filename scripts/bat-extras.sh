#!/bin/sh
# Install bat-extras — bat-powered scripts (batman, batgrep, batdiff, etc.)
# https://github.com/eth-p/bat-extras

set -e
if [ -d /tmp/bat-extras ]; then rm -rf /tmp/bat-extras; fi
git clone --depth 1 https://github.com/eth-p/bat-extras.git /tmp/bat-extras
sudo /tmp/bat-extras/build.sh --install --prefix /usr/local
rm -rf /tmp/bat-extras
echo "bat-extras installed: $(batman --version 2>/dev/null | head -1)"
