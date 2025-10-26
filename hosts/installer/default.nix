{ delib, ... }:
delib.host {
  name = "installer";

  type = "server";

  features = [
    "installer"
  ];

  myconfig = {
    networking.mode = "network-manager";
  };
}
