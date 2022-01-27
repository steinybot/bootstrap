{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  shellHook = ''
    pwd
    ls -la
    echo "hello from shell"
  '';
}

# TODO: Can we run home-manager with home-bootstrap in here somehow?
#home-manager -f "https://raw.githubusercontent.com/steinybot/bootstrap/main/home-bootstrap.nix" switch