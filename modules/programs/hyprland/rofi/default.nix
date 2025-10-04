{ delib, ... }:
delib.module {
  name = "programs.hyprland.rofi";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled = {
    programs.rofi = {
      enable = true;
    };
  };
}
