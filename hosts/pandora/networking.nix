{ delib, ... }:
delib.host {
  name = "pandora";

  myconfig.networking.mode = "network-manager";

  nixos = {
    networking = {
      hostId = "dabd7000";
      firewall.allowedTCPPorts = [ 22 ];
    };
  };
}
