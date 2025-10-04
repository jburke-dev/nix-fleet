{ delib, homeconfig, ... }:
delib.host {
  name = "desktop";

  type = "desktop";

  myconfig.programs.network-utils.enable = true;

  home.wayland.windowManager.hyprland.settings.monitor = [
    "HDMI-A-1, preferred, 0x0, 1"
    "DP-2, preferred, auto-right, 1"
  ];

  myconfig.programs.hyprland.displays = [
    {
      name = "HDMI-A-1";
      wallpaperPath = "${homeconfig.home.homeDirectory}/Pictures/Wallpapers/ultrawide/";
    }
    {
      name = "DP-2";
      wallpaperPath = "${homeconfig.home.homeDirectory}/Pictures/Wallpapers/hd/";
    }
  ];
  myconfig.programs.ssh = {
    sshRootDir = "/mnt/apps/ssh";
    keyConfigs = [
      {
        host = "github.com";
        identityFileSuffix = "github";
      }
      {
        host = "kaiju";
        hostname = "192.168.21.5";
      }
      {
        host = "colossus";
        hostname = "192.168.21.4";
      }
    ];
  };

  rice = "dark";
}
