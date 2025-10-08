{ delib, ... }:
delib.host {
  name = "kraken";

  nixos = {
    networking = {
      hostId = "daedb04a";

      firewall.interfaces = {
        "vlan-mgmt".allowedTCPPorts = [ 22 ];
      };
    };
  };

  myconfig.networking.systemd.vlans = {
    mgmt = {
      interface = "enp86s0";
      hostIp = "6";
      isDefault = true;
      metric = 100;
    };
    services = {
      interface = "enp87s0";
      hostIp = "4";
      metric = 200;
      routingTable = 101;
    };
  };
}
