{
  delib,
  host,
  pkgs,
  inputs,
  ...
}:
delib.module {
  name = "programs.hyprland.plugins";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled = {
    wayland.windowManager.hyprland = {
      plugins = [
        #pkgs.hyprlandPlugins.hyprexpo
        # inputs.hyprXPrimary.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
      settings.plugin = {
        /*
          hyprexpo = {
            skip_empty = true;
            columns = 2;
          };
        */
        /*
          xwaylandprimary = {
            display = "DP-1";
          };
        */
      };
    };
  };
}
