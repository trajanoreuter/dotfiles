#!/bin/sh
set -e

curl -s "https://get.sdkman.io" | bash

# shellcheck disable=SC1091
[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ] && . "$HOME/.sdkman/bin/sdkman-init.sh"

sdk install kotlin
sdk install gradle
