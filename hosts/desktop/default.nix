{ delib, ... }:
delib.host {
  name = "desktop";

  type = "desktop";

  myconfig.programs.network-utils.enable = true;

  home.wayland.windowManager.hyprland.settings.monitor = [
    "HDMI-A-1, preferred, 0x0, 1"
    "DP-2, preferred, auto-right, 1"
  ];
}
