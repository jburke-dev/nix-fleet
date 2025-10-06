{ delib, ... }:
delib.host {
  name = "kaiju";

  nixos = {
    networking = {
      hostId = "deadc0ff";

      firewall.interfaces = {
        "vlan-mgmt".allowedTCPPorts = [ 22 ];
      };

    };
  };

  myconfig.networking.systemd.vlans = {
    mgmt = {
      interface = "enp129s0f0";
      hostIp = "5";
      isDefault = true;
      metric = 100;
    };
    services = {
      interface = "enp129s0f1";
      hostIp = "2";
      metric = 200;
      routingTable = 101;
    };
    data = {
      interface = "enp129s0f0";
      hostIp = "2";
      metric = 300;
      routingTable = 102;
    };
  };
}
