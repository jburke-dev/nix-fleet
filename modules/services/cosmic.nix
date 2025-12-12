{ delib, host, ... }:
delib.module {
  name = "services.cosmic";

  options = delib.singleEnableOption host.cosmicFeatured;

  nixos.ifEnabled = {
    services = {
      displayManager.cosmic-greeter.enable = true;
      desktopManager.cosmic = {
        enable = true;
        xwayland.enable = true;
      };
    };
  };
}
