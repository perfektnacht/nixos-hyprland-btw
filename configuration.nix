# nix-command won't run with the ISO installer.  Use this command to install:
# rm /mnt/etc/nixos/flake.lock
# export NIX_CONFIG="experimental-features = nix-command flakes"
# nix flake lock /mnt/etc/nixos
# nixos-install --flake /mnt/etc/nixos#nixos-btw

{ 
  config, 
  lib, 
  pkgs, 
  inputs, 
  ... 
}:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-btw";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

# services.getty.autologinUser = "perfekt";

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
#    withUWSM = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  users.users.perfekt = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    wget
    ghostty
    playerctl
    git
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";

}
