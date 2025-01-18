{
  lib,
  username,
  host,
  config,
  ...
}:

let
  inherit (import ../hosts/${host}/variables.nix)
    browser
    terminal
    keyboardLayout
    ;
in
with lib;
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    extraConfig =
      let
	modifier = "SUPER";
      in
      concatStrings [
	''
          exec-once = sleep .5 && swww init
          exec-once = sleep .5 && waybar
	  monitor=eDP-1,preferred,1920x0,1
	  monitor=HDMI-A-1,1920x1080@120,0x0,1
          general {
            gaps_in = 6
            gaps_out = 8
            border_size = 2
            layout = dwindle
            resize_on_border = true
            col.active_border = rgb(${config.stylix.base16Scheme.base08}) rgb(${config.stylix.base16Scheme.base0C}) 45deg
            col.inactive_border = rgb(${config.stylix.base16Scheme.base01})
          }
          input {
            kb_layout = ${keyboardLayout}
            follow_mouse = 1
            touchpad {
              natural_scroll = true
              disable_while_typing = true
              scroll_factor = 0.8
            }
            sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
            accel_profile = flat
          }
          windowrule = noborder,^(wofi)$
          windowrule = center,^(wofi)$
          windowrule = center,^(steam)$
          windowrule = float, nm-connection-editor|blueman-manager
          windowrule = float, swayimg|vlc|Viewnior|pavucontrol
          windowrule = float, nwg-look|qt5ct|mpv
          windowrule = float, zoom
          windowrulev2 = stayfocused, title:^()$,class:^(steam)$
          windowrulev2 = minsize 1 1, title:^()$,class:^(steam)$
          windowrulev2 = opacity 0.9 0.7, class:^(Brave)$
          windowrulev2 = opacity 0.9 0.7, class:^(thunar)$
	  bind = ${modifier},Q,killactive,
	  bind = ${modifier},F,fullscreen,
	  bind = ${modifier}SHIFT,F,togglefloating,
	  bind = ${modifier}SHIFT,left,movewindow,l
          bind = ${modifier}SHIFT,right,movewindow,r
          bind = ${modifier}SHIFT,up,movewindow,u
          bind = ${modifier}SHIFT,down,movewindow,d
	  bind = ${modifier}SHIFT,h,movewindow,l
          bind = ${modifier}SHIFT,l,movewindow,r
          bind = ${modifier}SHIFT,k,movewindow,u
          bind = ${modifier}SHIFT,j,movewindow,d
	  bind = ${modifier},left,movefocus,l
          bind = ${modifier},right,movefocus,r
          bind = ${modifier},up,movefocus,u
          bind = ${modifier},down,movefocus,d
          bind = ${modifier},h,movefocus,l
          bind = ${modifier},l,movefocus,r
          bind = ${modifier},k,movefocus,u
          bind = ${modifier},j,movefocus,d
          bind = ${modifier},1,workspace,1
          bind = ${modifier},2,workspace,2
          bind = ${modifier},3,workspace,3
          bind = ${modifier},4,workspace,4
          bind = ${modifier},5,workspace,5
          bind = ${modifier},6,workspace,6
          bind = ${modifier},7,workspace,7
          bind = ${modifier},8,workspace,8
          bind = ${modifier},9,workspace,9
          bind = ${modifier},0,workspace,10
	  bind = ${modifier}SHIFT,1,movetoworkspacesilent,1
          bind = ${modifier}SHIFT,2,movetoworkspacesilent,2
          bind = ${modifier}SHIFT,3,movetoworkspacesilent,3
          bind = ${modifier}SHIFT,4,movetoworkspacesilent,4
          bind = ${modifier}SHIFT,5,movetoworkspacesilent,5
          bind = ${modifier}SHIFT,6,movetoworkspacesilent,6
          bind = ${modifier}SHIFT,7,movetoworkspacesilent,7
          bind = ${modifier}SHIFT,8,movetoworkspacesilent,8
          bind = ${modifier}SHIFT,9,movetoworkspacesilent,9
          bind = ${modifier}SHIFT,0,movetoworkspacesilent,10
	  bind = ${modifier},T,exec,${terminal}
	  bind = ${modifier},SPACE,exec,rofi -show drun
	  bind = ${modifier},I,exec,${browser}
	  bind = ${modifier},D,exec,discord --use-gl=desktop --enable-gpu-rasterization
	  bind = ${modifier},E,exec,thunar
	  bindm = ${modifier},mouse:272,movewindow
          bindm = ${modifier},mouse:273,resizewindow
	  bind = ALT,Tab,cyclenext
          bind = ALT,Tab,bringactivetotop
	''
      ];
  };
}
