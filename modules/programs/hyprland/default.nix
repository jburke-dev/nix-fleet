{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.hyprland";

  options = delib.singleEnableOption host.hyprlandFeatured;

  nixos.ifEnabled = {
    services.xserver.displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_DISABLE_RDD_SANDBOX = "1";
      MOZ_WEBRENDER = "1";
    };
  };

  home.ifEnabled = {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$terminal" = "ghostty";
        "$browser" = "zen";
        "$mainMod" = "SUPER";

        misc = {
          disable_hyprland_logo = true;
          force_default_wallpaper = 0;
        };

        exec-once = [
          "waybar"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        bind = [
          "$mainMod, q, killactive,"
          "$mainMod, T, exec, $terminal"
          "$mainMod, B, exec, $browser"
          "$mainMod, M, fullscreen, 1"

          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"

          "$mainMod SHIFT, 1, workspace, 1"
          "$mainMod SHIFT, 2, workspace, 2"
          "$mainMod SHIFT, 3, workspace, 3"
          "$mainMod SHIFT, 4, workspace, 4"
          "$mainMod SHIFT, 5, workspace, 5"
          "$mainMod SHIFT, 6, workspace, 6"
          "$mainMod SHIFT, 7, workspace, 7"
          "$mainMod SHIFT, 8, workspace, 8"
          "$mainMod SHIFT, 9, workspace, 9"
        ];
      };
    };
  };
}
