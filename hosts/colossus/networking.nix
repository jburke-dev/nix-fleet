{ delib, ... }:
delib.host {
  name = "colossus";

  nixos = {
    networking = {
      hostId = "deadc100";

      firewall.interfaces = {
        "vlan-mgmt".allowedTCPPorts = [ 22 ];
      };

    };
  };

  myconfig.networking.systemd.vlans = {
    mgmt = {
      interface = "enp1s0f0";
      hostIp = "4";
      isDefault = true;
      metric = 100;
    };
    services = {
      interface = "enp1s0f1";
      hostIp = "3";
      metric = 200;
      routingTable = 101;
    };
    data = {
      interface = "enp1s0f0";
      hostIp = "3";
      metric = 300;
      routingTable = 102;
    };
    monitoring = {
      interface = "enp1s0f0";
      hostIp = "4";
      metric = 400;
      routingTable = 103;
    };
  };
}
