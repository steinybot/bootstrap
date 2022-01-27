{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  shellHook = ''
    set -x
    home-manager -f '${./home-bootstrap.nix}' switch
  '';
}