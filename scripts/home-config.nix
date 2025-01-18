{ pkgs }:

pkgs.writeShellScriptBin "home-config" ''
  nano /etc/nixos/hosts/$(hostname)/home.nix
''
