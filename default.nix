{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    git
  ];
  shellHook = ''
    set -euo pipefail
    set -x
    home-manager -f '${./home-bootstrap.nix}' -b 'backup-before-bootstrap' -v switch
  '';
}