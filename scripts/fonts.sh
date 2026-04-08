#!/bin/sh

# homebrew/cask-fonts was deprecated May 2024; fonts are now in the main homebrew-cask repo.
# No tap needed — just install directly.
brew search '/font-.*-nerd-font/' | awk '{ print $1 }' | xargs -I{} brew install --cask {} || true
