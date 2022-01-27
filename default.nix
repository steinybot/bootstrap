{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    git
  ];
  shellHook = ''
    set -euo pipefail
    home-manager -f '${./home-bootstrap.nix}' -b 'backup-before-bootstrap' switch
  '';
}