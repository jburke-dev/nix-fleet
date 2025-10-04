{ delib, homeconfig, ... }:
delib.host {
  name = "desktop";

  type = "desktop";

  myconfig.programs.network-utils.enable = true;

  home.wayland.windowManager.hyprland.settings.monitor = [
    "HDMI-A-1, preferred, 0x0, 1"
    "DP-2, preferred, auto-right, 1"
  ];

  myconfig.programs.hyprland.displays = {
    "HDMI-A-1".wallpaperPath = "${homeconfig.home.homeDirectory}/Pictures/Wallpapers/ultrawide/";
    "DP-2".wallpaperPath = "${homeconfig.home.homeDirectory}/Pictures/Wallpapers/hd/";
  };

  rice = "dark";
}
