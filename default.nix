{ pkgs ? import <nixpkgs> {} }:

let
  # The path to the dotfiles repository once it has been checked out.
  dotFilesRepo = fetchGit {
    url = "https://github.com/steinybot/dotfiles.git";
    ref = "main";
  };

  homeNixFile = "${dotFilesRepo}/home/.config/nixpkgs/home.nix";
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    git
  ];
  shellHook = ''
    set -euo pipefail
    home-manager -f '${homeNixFile}' -b 'backup-before-bootstrap' -v switch
  '';
}