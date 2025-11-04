{ delib, ... }:
delib.host {
  name = "laptop";

  type = "laptop";
  myconfig.programs.network-utils.enable = true;
  rice = "dark";
}
