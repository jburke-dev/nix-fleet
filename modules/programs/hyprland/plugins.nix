{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.hyprland.plugins";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled = {
    wayland.windowManager.hyprland = {
      plugins = [
        pkgs.hyprlandPlugins.hyprexpo
      ];
      settings.plugin.hyprexpo = {
        skip_empty = true;
        columns = 2;
      };
    };
  };
}
