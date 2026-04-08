#!/bin/sh

XH_INSTALL_DIR="${XH_INSTALL_DIR:-$HOME/.local/bin}"
mkdir -p "$XH_INSTALL_DIR"
curl -sfL https://raw.githubusercontent.com/ducaale/xh/master/install.sh | XH_BINDIR="$XH_INSTALL_DIR" sh
