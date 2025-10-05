{ delib, lib, ... }:
delib.module {
  name = "programs.hyprland.rofi";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled = {
    programs.rofi = {
      enable = true;
      terminal = "xdg-terminal-exec";
      font = lib.mkForce "SauceCodePro Nerd Font Propo 16";
    };
  };
}
