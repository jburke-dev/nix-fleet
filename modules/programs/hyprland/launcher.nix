{
  delib,
  ...
}:
delib.module {
  name = "programs.hyprland.launcher";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled = {
    programs.rofi = {
      enable = true;
    };

    wayland.windowManager.hyprland.settings = {
      bind = [
        "$mainMod SHIFT, Return, exec, pkill rofi || rofi -show drun -replace -i"
      ];
    };
  };
}
