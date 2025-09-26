{ delib, lib, ... }:
let
  mgmt = {
    interface = "enp1s0f0";
    id = 21;
  };
  services = {
    interface = "enp1s0f1";
    id = 11;
  };
in
delib.host {
  name = "colossus";

  nixos = {
    networking = {
      hostId = "deadc0ff";

      firewall.interfaces = {
        "vlan-mgmt".allowedTCPPorts = [ 22 ];
      };
    };

    systemd.network = {
      netdevs = {
        # TODO: map attrs here?
        "20-vlan-mgmt" = {
          netdevConfig = {
            Kind = "vlan";
            Name = "vlan-mgmt";
          };
          vlanConfig.Id = mgmt.id;
        };
        "20-vlan-services" = {
          netdevConfig = {
            Kind = "vlan";
            Name = "vlan-services";
          };
          vlanConfig.Id = services.id;
        };
      };
      networks = {
        "30-${mgmt.interface}" = {
          matchConfig.Name = mgmt.interface;
          vlan = [ "vlan-mgmt" ];
          linkConfig.RequiredForOnline = "carrier";
          networkConfig = {
            DHCP = "no";
          };
        };
        "30-${services.interface}" = {
          matchConfig.Name = services.interface;
          vlan = [ "vlan-services" ];
          linkConfig.RequiredForOnline = "no";
          networkConfig = {
            DHCP = "no";
          };
        };
        "40-vlan-mgmt" = {
          matchConfig.Name = "vlan-mgmt";
          networkConfig = {
            DHCP = "no";
          };
          address = [ "192.168.21.4/24" ];
          routes = [
            {
              Destination = "0.0.0.0/0";
              Gateway = "192.168.21.1";
              Metric = 100;
            }
          ];
          linkConfig.RequiredForOnline = "yes";
        };
        "40-vlan-services" = {
          matchConfig.Name = "vlan-services";
          networkConfig = {
            DHCP = "no";
          };
          address = [ "192.168.11.3/24" ];
          routingPolicyRules = [
            {
              From = "192.168.11.3";
              Table = 101;
              Priority = 110;
            }
            {
              From = "192.168.11.0/24";
              Table = 101;
              Priority = 111;
            }
          ];
          routes = [
            {
              Destination = "192.168.11.0/24";
              Scope = "link";
              Table = 101;
            }
            {
              Destination = "0.0.0.0/0";
              Gateway = "192.168.11.1";
              Table = 101;
              Metric = 200;
            }
          ];
          linkConfig.RequiredForOnline = "no";
        };
      };
      wait-online = {
        timeout = 30;
        anyInterface = true;
      };
    };
  };
}
