{ delib, host, ... }:
delib.module {
  name = "programs.kde";

  options = delib.singleEnableOption host.kdeFeatured;

  nixos.ifEnabled = {
    services = {
      desktopManager.plasma6.enable = true;
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
  };
}
