{ delib, homeconfig, ... }:
delib.host {
  name = "laptop";

  type = "laptop";
  myconfig.programs.network-utils.enable = true;
  myconfig.networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];
  rice = "dark";
}
