{
  pkgs,
  username,
  ...
}:

let
  inherit (import ./variables.nix) gitUsername shell;
in
{
  users.users.${username} = {
      isNormalUser = true;
      description = "${gitUsername}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
        "scanner"
        "lp"
      ];
      shell = pkgs.${shell};
      packages = with pkgs; [];
  };
}
