{ delib, ... }:
delib.host {
  name = "desktop";

  type = "desktop";

  myconfig.programs.network-utils.enable = true;
}
