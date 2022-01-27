#!/usr/bin/env sh

# This script bootstraps a new macOS machine.

{ # Prevent execution if this script was only partially downloaded.

  set -euo pipefail

  echo "Downloading and running Nix installer"

  # Install Nix.
  # See https://nixos.org/download.html#nix-install-macos.
  sh <(curl -L https://nixos.org/nix/install)

  echo "Downloading the setup script and running in a sub shell"

  # Continue the rest of the install in a new shell.
  sh <(curl -L https://raw.githubusercontent.com/steinybot/bootstrap/main/setup.sh)

} # End of wrapping.
