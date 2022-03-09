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
    local command
    read -r -d '' command <<EOM ||
set -euo pipefail
echo
read -r -s -p $'Press enter/return to start LastPass to get Apple ID password.\n'
lpass login '${LPASS_USERNAME}'
lpass show --clip --password '${LPASS_APPLE_ID}'
echo
echo "Please sign in to the App Store."
echo "Apple ID Password has been copied to the clipboard."
open -a "App Store"
read -r -s -p $'Press enter/return when complete.\n'
exit 0
EOM
true # Ignore the non-zero exit code from read.
    nix-shell -p lastpass-cli pinentry --command "${command}"
  }

  auto_install_xcode() {
    echo "Installing Xcode"
    mas purchase 497799835
  }

  manual_install_xcode() {
    echo
    echo "Please manually install Xcode from the App Store."
    open -a "App Store"
    read -r -s -p $'Press enter/return when complete.\n'
  }

  install_xcode() {
    mas account >/dev/null 2>&1 || sign_in_to_app_store
    auto_install_xcode || manual_install_xcode
    echo
    echo "Please approve the Xcode license agreement."
    sudo xcodebuild -license
  }

  install_home_manager() {
    echo "Installing Home Manager"
    # Home manager must be added as a channel or else you run into https://github.com/nix-community/home-manager/issues/1267.
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    nix-shell '<home-manager>' -A install
    # Once installed the channels can be deleted (we add them back in with home manager but avoid the unnecessary backup).
    rm ~/.nix-channels
  }

  install_nix_darwin() {
    echo "Installing nix-darwin"
    NIX_DARWIN_TEMP_DIR="$(mktemp -d -t steinybot-bootstrap_nix-darwin)"
    trap 'rm -rf -- "$NIX_DARWIN_TEMP_DIR"' EXIT
    nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer --out-link "${NIX_DARWIN_TEMP_DIR}/result"
    "${NIX_DARWIN_TEMP_DIR}/result/bin/darwin-installer"
    rm -rf -- "$NIX_DARWIN_TEMP_DIR"
  }

  [ -e '/Applications/Xcode.app' ] || install_xcode

  command -v home-manager >/dev/null 2>&1 || install_home_manager

  command -v darwin-rebuild >/dev/null 2>&1 || install_nix_darwin

  # This is a hack to bootstrap home manager. Is there a better way?
  nix-shell "https://github.com/steinybot/bootstrap/archive/main.tar.gz" --option tarball-ttl 0 --run "exit"

}

# End of wrapping.
