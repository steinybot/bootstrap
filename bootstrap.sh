#!/usr/bin/env sh

# This script bootstraps a new macOS machine.

{ # Prevent execution if this script was only partially downloaded.

  # Install Nix.
  # See https://nixos.org/download.html#nix-install-macos.
  #sh <(curl -L https://nixos.org/nix/install)

  # Continue the rest of the install in a new shell.
  sh <(curl -L https://setup.example.com)

} # End of wrapping.
