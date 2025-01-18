# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, host, username, ... }:
let
  inherit (import ./variables.nix) keyboardLayout keymap;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./users.nix
      ../../modules/battery.nix
      ../../modules/nvidia.nix
      ../../modules/intel.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = host;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.insertNameservers = [ "94.140.14.14" "94.140.15.15" ];

  # for vpn
  networking.firewall.allowedUDPPorts = [ 65155 ];

  # Set your time zone.
  time.timeZone = "Europe/Istanbul";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "tr_TR.UTF-8";
    LC_IDENTIFICATION = "tr_TR.UTF-8";
    LC_MEASUREMENT = "tr_TR.UTF-8";
    LC_MONETARY = "tr_TR.UTF-8";
    LC_NAME = "tr_TR.UTF-8";
    LC_NUMERIC = "tr_TR.UTF-8";
    LC_PAPER = "tr_TR.UTF-8";
    LC_TELEPHONE = "tr_TR.UTF-8";
    LC_TIME = "tr_TR.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    xkb = {
      layout = keyboardLayout;
      variant = "";
    };
    excludePackages = [ pkgs.xterm ];
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };

  # Configure console keymap
  console.keyMap = keymap;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    git
    tmux
    eza
    waybar
    kitty
    dunst
    libnotify
    networkmanagerapplet
    pavucontrol
    hyprpaper
    swww
    rofi-wayland
    rustup
    home-manager
    openvpn
    libsecret
    virtualglLib
    (import ../../scripts/hyprland-config.nix { inherit pkgs; })
    (import ../../scripts/nix-config.nix { inherit pkgs; })
    (import ../../scripts/home-config.nix { inherit pkgs; })
    (import ../../scripts/set-brightness.nix { inherit pkgs; })
    (import ../../scripts/nvidia-offload.nix { inherit pkgs; })
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # hyprland setup
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # fish shell
  programs.fish.enable = true;

  # thunar file explorer
  programs.xfconf.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  # gnome keyring
  services.gnome.gnome-keyring.enable = true;

 /*  programs.git = {
    enable = true;
    config.init.defaultBranch = "main";
  }; */

  environment.sessionVariables = {
    # If your cursor becomes invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts-emoji
      noto-fonts-cjk-sans
      font-awesome
      symbola
      material-icons
    ];
  };


  # stylix
  stylix = {
    image = ../../config/wallpapers/beautifulmountainscape.jpg;
  };

  # xdg.portal.enable = true;
  # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland ];

  security = {
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # docker
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # vpn (using custom openvpn server right now so no need for this)
  # services.mullvad-vpn.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable touchpad
  services.libinput.enable = true;

  services.dbus.enable = true;

  # for battery readout (upower -d)
  services.upower.enable = true;
  
  # OpenVPN daemon
  services.openvpn.servers.rayoVPN.config = '' config /home/cozfuttu/.vpn/can-nixos.ovpn '';

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
