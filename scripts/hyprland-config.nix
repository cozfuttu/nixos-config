{ pkgs }:

pkgs.writeShellScriptBin "hyprland-config" ''
  nano /etc/nixos/config/hyprland.nix
''
