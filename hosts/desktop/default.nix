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
          host = "pandora";
          hostname = "10.10.0.1"; # not using hostname just incase dns breaks
        }
        {
          host = "kraken";
          hostname = "10.12.1.1";
        }
        {
          host = "kaiju";
          hostname = "10.12.1.2";
        }
        {
          host = "glados";
          hostname = "10.12.1.3";
        }
        {
          host = "colossus";
          hostname = "10.12.1.4";
        }
      ];
    };
  };

  rice = "dark";
}
