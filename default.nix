{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    git
  ];
  shellHook = ''
    home-manager -f '${./home-bootstrap.nix}' switch
  '';
}