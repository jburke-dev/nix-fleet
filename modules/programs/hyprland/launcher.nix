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
        "$mainMod, Return, exec, pkill rofi || rofi -show combi -modes combi -combi-modes \"window,drun\" -show-icons -replace -i"
        "$mainMod, W, exec, pkill rofi || rofi -show window -show-icons -replace -i"
        "$mainMod, K, exec, pkill rofi || rofi -show keys -replace -i"
      ];
    };
  };
}
