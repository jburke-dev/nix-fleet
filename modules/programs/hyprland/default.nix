{
  delib,
  host,
  lib,
  pkgs,
  inputs,
  ...
}:
delib.module {
  name = "programs.hyprland";

  options =
    with delib;
    moduleOptions {
      enable = boolOption host.hyprlandFeatured;
      displays = listOfOption (submodule (
        { config, ... }:
        {
          options = {
            name = strOption null;
            wallpaperPath = pathOption null;
            resolution = strOption "preferred";
            leftMost = boolOption false;
          };
        }
      )) [ ];
      gaps = {
        inner = intOption 5;
        outer = intOption 20;
      };
      border = {
        size = intOption 1;
        radius = intOption 0;
        inactive_color = strOption "0xff444444";
        active_color = strOption "0x6620ddff"; # #6620dd
      };
      shadow = {
        range = intOption 4;
        power = intOption 3;
        offset = strOption "0 0";
        scale = floatOption 1.0;
        color = strOption "0xee1a1a1a"; # #ee1a1a
        inactive_color = allowNull (strOption null);
      };
      workspacesPerDisplay = intOption 4;
    };

  nixos.ifEnabled = {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_DISABLE_RDD_SANDBOX = "1";
      MOZ_WEBRENDER = "1";
    };
  };

  home.ifEnabled =
    { cfg, ... }:
    {
      services.hyprpolkitagent.enable = true;
      wayland.windowManager.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;

        settings = {
          "$terminal" = "ghostty";
          "$browser" = "zen-twilight";
          "$mainMod" = "SUPER";
          exec-once = [
            "ags-shell"
            "obsidian ~/obsidian-vaults/sol"
          ];

          general = {
            gaps_in = cfg.gaps.inner;
            gaps_out = cfg.gaps.outer;
            border_size = cfg.border.size;
            "col.inactive_border" = cfg.border.inactive_color;
            "col.active_border" = cfg.border.active_color;

            snap = {
              enabled = true;
              window_gap = 10;
              monitor_gap = 10;
              border_overlap = true;
            };
          };

          decoration = {
            rounding = cfg.border.radius;
            shadow = {
              inherit (cfg.shadow)
                range
                offset
                scale
                color
                ;
              enabled = true;
              render_power = cfg.shadow.power;
              color_inactive = lib.mkIf (cfg.shadow.inactive_color != null) cfg.shadow.inactive_color;
            };
          };

          dwindle = {
            split_width_multiplier = 1.5;
          };

          misc = {
            disable_hyprland_logo = true;
            force_default_wallpaper = 0;
          };
        };
      };
    };
}
