{ delib, homeconfig, ... }:
delib.host {
  name = "laptop";

  type = "laptop";
  myconfig.programs = {
    network-utils.enable = true;
    ssh = {
      keyConfigs = [
        {
          host = "github.com";
          identityFileSuffix = "github";
        }
      ];
    };
    hyprland.displays = [
      {
        name = "eDP-1";
        resolution = "1920x1200@120.00Hz";
        wallpaperPath = "${homeconfig.home.homeDirectory}/Pictures/Wallpapers/ultrawide/";
        leftMost = true;
      }
    ];
  };
  rice = "dark";
}
