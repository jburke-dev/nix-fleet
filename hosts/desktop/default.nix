{ delib, homeconfig, ... }:
delib.host {
  name = "desktop";

  type = "desktop";

  nixos.networking = {
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    networkmanager.dns = "none";
  };

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
        {
          host = "pandora";
          hostname = "192.168.5.24";
        }
      ];
    };
  };

  rice = "dark";
}
