{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  shellHook = ''
    home-manager -f '${./home-bootstrap.nix}' switch
  '';
}