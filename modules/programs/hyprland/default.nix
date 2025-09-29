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
    services.hyprpolkitagent.enable = true;
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
      };
    };
  };
}
