{ pkgs }:

pkgs.writeShellScriptBin "nix-config" ''
  nano /etc/nixos/hosts/$(hostname)/configuration.nix
''
