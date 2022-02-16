#!/usr/bin/env bash

# This script bootstraps a new macOS machine.

{ # Prevent execution if this script was only partially downloaded.

  set -euo pipefail

  install_nix() {
    echo "Downloading and running Nix installer"

    sh <(curl -L https://nixos.org/nix/install)
  }

  # Install Nix.
  # See https://nixos.org/download.html#nix-install-macos.
  [ -e /nix ] || install_nix

  install_xcode() {
    echo "Installing Xcode"

    xcode-select --install
  }

  # Install Xcode.
  xcode-select -p >/dev/null || install_xcode

  echo "Downloading the setup script and running in a sub shell"

  # Continue the rest of the install in a new shell.
  sh <(curl -L https://raw.githubusercontent.com/steinybot/bootstrap/main/setup.sh)

} # End of wrapping.
