{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "jason";
  home.homeDirectory = "/Users/jason";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Link home.nix from the dotfiles repository.
  home.file."home.nix".source = "${fetchGit {
    url = "https://github.com/steinybot/dotfiles.git";
    ref = "main";
  }}/.config/nixpkgs/home.nix";
}