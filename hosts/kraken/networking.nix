{ delib, ... }:
delib.host {
  name = "kraken";

  nixos = {
    networking = {
      hostId = "daedb04a";

      firewall.interfaces = {
        "vlan-mgmt".allowedTCPPorts = [
          22
          6443
        ];
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
    k3s = {
      interface = "enp86s0";
      hostIp = "2";
      metric = 400;
      # No routing table - prevents policy routing rules that break pod networking
    };
    # TODO: physical interface names seem to change between reboots -_-
    iot = {
      interface = "enp88s0";
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
