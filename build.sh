#!/bin/bash
set -e
cd "$(dirname "$0")"

nix fmt

# Detect the current platform so the matching homeConfigurations.<system> is used.
system=$(nix eval --impure --raw --expr 'builtins.currentSystem')

# Use the installed home-manager if present, otherwise run it from the flake
# (e.g. on first run before home-manager is in the profile).
if command -v home-manager >/dev/null 2>&1; then
  home-manager switch --flake ".#${system}" --impure
else
  nix run home-manager/master -- switch --flake ".#${system}" --impure
fi
