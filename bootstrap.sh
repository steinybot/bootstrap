#!/usr/bin/env bash

# This script bootstraps a new macOS machine.

{ # Prevent execution if this script was only partially downloaded.

  set -euo pipefail

  install_nix() {
    echo "Downloading and running Nix installer."

    sh <(curl -L https://nixos.org/nix/install)
  
    echo "Please restart your shell and run this script again to continue."
    exit 0
  }
  
  check_nix() {
    if ! command -v nix &> /dev/null; then
      echo "Could not find nix. You probably need to restart your shell."
      exit 1
    fi
  }

  # Install Nix.
  # See https://nixos.org/download.html#nix-install-macos.
  [ -e /nix ] || install_nix
  
  check_nix

  echo "Downloading and running the setup script."

  # Continue the rest of the setup.
  bash <(curl -L https://raw.githubusercontent.com/steinybot/bootstrap/main/setup.sh)

} # End of wrapping.
