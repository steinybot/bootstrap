#!/usr/bin/env bash

# This script continues the bootstrap setup of a new macOS machine.

{ # Prevent execution if this script was only partially downloaded.

  set -euo pipefail

  # Set NIX_PATH explicitly to work around https://github.com/NixOS/nixpkgs/issues/149791.
  # The path is the same as the default when NIX_PATH is not set (https://github.com/NixOS/nix/blob/master/src/libexpr/eval.cc).
  NIX_STATE_DIR="/nix/var/nix"
  export NIX_PATH="${NIX_PATH:-${HOME}/.nix-defexpr/channels:nixpkgs=${NIX_STATE_DIR}/profiles/per-user/root/channels/nixpkgs:${NIX_STATE_DIR}/profiles/per-user/root/channels}"

  LPASS_USERNAME="jasonpickensnz@gmail.com"
  LPASS_APPLE_ID="3603553886062660982"

  sign_in_to_app_store() {
    set -x
    local command
    read -r -d '' command <<EOM
    echo hello
EOM
    nix-shell -p lastpass-cli pinentry --command "${command}"

    # TODO: Get Apple ID password and read for enter key.
    exit 1
  }

  install_xcode() {
    sign_in_to_app_store

    echo "Installing Xcode"

    # TODO: Use mas to install Xcode.
    exit 1
  }

  # Install Xcode.
  # TODO: Look for Applications/Xcode.app.
  install_xcode

  install_home_manager() {
    echo "Installing Home Manager"

    nix-shell "https://github.com/nix-community/home-manager/archive/master.tar.gz" -A install
  }

  command -v home-manager >/dev/null || install_home_manager

  # This is a hack to bootstrap home manager. Is there a better way?
  # The double nix-shell gives us git in case XCode hasn't been setup yet.
  nix-shell -p git --run 'nix-shell "https://github.com/steinybot/bootstrap/archive/main.tar.gz" --option tarball-ttl 0 --run "exit"'

}

# End of wrapping.
