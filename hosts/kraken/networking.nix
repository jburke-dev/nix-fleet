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
    iot = {
      interface = "enp87s0";
      hostIp = "2";
      metric = 200;
      routingTable = 101;
    };
    monitoring = {
      interface = "enp86s0";
      hostIp = "6";
      metric = 300;
      routingTable = 102;
    };
  };

  # Route services subnet traffic through IOT VLAN for proper return path
  nixos.systemd.network.networks."40-vlan-iot".routingPolicyRules = [
    {
      To = "192.168.11.0/24";
      Table = 101;
      Priority = 100;
    }
  ];
}
