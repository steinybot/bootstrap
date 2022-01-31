#!/usr/bin/env bash

# This script continues the bootstrap setup of a new macOS machine.

{ # Prevent execution if this script was only partially downloaded.

  set -euo pipefail

  # Set NIX_PATH explicitly to work around https://github.com/NixOS/nixpkgs/issues/149791.
  # The path is the same as the default when NIX_PATH is not set (https://github.com/NixOS/nix/blob/master/src/libexpr/eval.cc).
  NIX_STATE_DIR="/nix/var/nix"
  export NIX_PATH="${NIX_PATH:-${HOME}/.nix-defexpr/channels:nixpkgs=${NIX_STATE_DIR}/profiles/per-user/root/channels/nixpkgs:${NIX_STATE_DIR}/profiles/per-user/root/channels}"

  command -v home-manager || nix-shell "https://github.com/nix-community/home-manager/archive/master.tar.gz" -A install

  # This is a hack to bootstrap home manager. Is there a better way?
  # The double nix-shell gives us git in case XCode hasn't been setup yet.
  nix-shell -p git --run 'nix-shell "https://github.com/steinybot/bootstrap/archive/main.tar.gz" --option tarball-ttl 0 --run "exit"'

}

# End of wrapping.
