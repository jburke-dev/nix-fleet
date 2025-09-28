{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.hyprland.window-rules";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled = {
    wayland.windowManager.hyprland = {
      settings = {
        windowrule = [
          "workspace 5, class:zen-twilight"
        ];
      };
    };
  };
}
