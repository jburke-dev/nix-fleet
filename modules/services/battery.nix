{ delib, host, ... }:
delib.module {
  name = "services.battery";

  options = delib.singleEnableOption host.isLaptop;

  nixos.ifEnabled = {
    services.upower = {
      enable = true;
      noPollBatteries = true;
    };
  };
}
