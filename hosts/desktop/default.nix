{ delib, homeconfig, ... }:
delib.host {
  name = "desktop";

  type = "desktop";

  myconfig.programs = {
    network-utils.enable = true;
    hyprland.displays = [
      {
        name = "DP-1";
        wallpaperPath = "${homeconfig.home.homeDirectory}/Pictures/Wallpapers/ultrawide/";
        resolution = "3440x1440@100.00Hz";
        leftMost = true;
      }
      {
        name = "DP-2";
        wallpaperPath = "${homeconfig.home.homeDirectory}/Pictures/Wallpapers/hd/";
      }
    ];
    ssh = {
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
        {
          host = "kraken";
          hostname = "192.168.21.6";
        }
      ];
    };
  };

  rice = "dark";
}
