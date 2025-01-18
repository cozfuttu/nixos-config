{ config, pkgs, host, ... }:

let
  inherit (import ./variables.nix) gitUsername gitEmail;
in
{
  home.username = "cozfuttu";
  home.homeDirectory = "/home/cozfuttu";
  home.stateVersion = "24.11";

  imports = [
    ../../config/hyprland.nix
    ../../config/waybar.nix
    ../../config/rofi/rofi.nix
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    hello
    chromium
    vscode
    helix
    whatsapp-for-linux
    discord
    docker
    obsidian
    github-desktop
    figma-linux
    neofetch
    (google-chrome.override {
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
        "--use-gl=desktop"
        "--enable-gpu-rasterization"
      ];
    })
  ];

  home.file = {

  };

  programs = {
    kitty.enable = true;
    fish = {
      enable = true;
      shellAliases = {
	ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
	nrs = "sudo nixos-rebuild switch --flake /etc/nixos/.#${host}";
	nrt = "sudo nixos-rebuild test --flake /etc/nixos/.#${host}";
	nfu = "nix flakes update";
	".." = "cd ..";
      };
      interactiveShellInit = ''
        ${pkgs.neofetch}/bin/neofetch
      '';
    };
    git = {
      enable = true;
      userName = "${gitUsername}";
      userEmail = "${gitEmail}";
      extraConfig = {
        push = { autoSetupRemote = true; };
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true; # enable Hyprland
    xwayland.enable = true;
  };

/*  programs.git = {
   enable = true;
    userName = "cozfuttu";
    userEmail = "canozfuttu07@gmail.com";
    extraConfig = {
      credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
      init.defaultBranch = "main";
      safe.directory = "/etc/nixos";
    };
  }; */

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/cozfuttu/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
