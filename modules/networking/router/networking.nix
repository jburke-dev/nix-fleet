{ delib, lib, ... }:
let
  netLib = import ../../lib/networking.nix { inherit lib; };
in
delib.module {
  name = "networking.router";

  nixos.ifEnabled =
    { parent, ... }:
    let
      inherit (parent.networks) lan;
      vlans = lib.filterAttrs (n: v: v.type == "vlan") parent.networks;

      mkVlanNetdev = name: network: {
        netdevConfig = {
          Name = netLib.getVlanInterfaceName name;
          Kind = "vlan";
        };
        vlanConfig.Id = network.id;
      };

      mkVlanNetwork = name: network: {
        matchConfig.Name = netLib.getVlanInterfaceName name;
        address = [
          "${netLib.vlanIp network "0.1"}/${toString network.cidr}"
          "${netLib.vlanGatewayV6 network}/64"
        ];
        networkConfig = {
          IPv6AcceptRA = false;
          IPv6SendRA = true;
        };
        ipv6SendRAConfig = {
          Managed = false;
          OtherInformation = true;
          EmitDNS = true;
          DNS = [ "_link_local" ];
          EmitDomains = true;
          Domains = [ parent.domain ];
        };
        ipv6Prefixes = [
          {
            Prefix = netLib.vlanSubnetV6 network;
            PreferredLifetimeSec = 1800;
            ValidLifetimeSec = 3600;
          }
        ];
      };
    in
    {
      systemd.network = {
        enable = true;
        links = lib.mapAttrs' (
          name: linkCfg:
          lib.nameValuePair "${toString linkCfg.priority}-${name}" (netLib.mkEthLink name linkCfg)
        ) parent.links;
        netdevs = {
          "10-bond0" = {
            netdevConfig = {
              Kind = "bond";
              Name = "bond0";
            };
            bondConfig = {
              Mode = "802.3ad";
              TransmitHashPolicy = "layer2+3";
            };
          };
          "20-br-lan" = {
            netdevConfig = {
              Kind = "bridge";
              Name = "br-lan";
              MACAddress = "02:01:03:00:04:ff";
            };
            bridgeConfig = {
              STP = true;
              ForwardDelaySec = 4;
              HelloTimeSec = 2;
              MaxAgeSec = 20;
            };
          };
        }
        // lib.mapAttrs' (
          name: network: lib.nameValuePair "20-vlan-${name}" (mkVlanNetdev name network)
        ) vlans;
        networks = {
          "10-wan" = {
            matchConfig.Name = "wan";
            networkConfig.DHCP = "yes";
            dhcpV4Config = {
              UseDNS = false;
              UseDomains = false;
              SendRelease = false;
              RouteMetric = 100;
            };
            dhcpV6Config = {
              PrefixDelegationHint = "::/60";
              UseDNS = false;
            };
            ipv6AcceptRAConfig = {
              UseDNS = false;
              UseDomains = false;
            };
            linkConfig.RequiredForOnline = "routable";
          };
          "11-lan1" = netLib.mkBridgeNetwork "lan1" lan.interface;
          "11-lan2" = netLib.mkBridgeNetwork "lan2" lan.interface;
          "11-lan3" = netLib.mkBridgeNetwork "lan3" lan.interface;
          "15-${lan.interface}" = {
            matchConfig.Name = lan.interface;
            address = [
              "${netLib.vlanIp lan "0.1"}/${toString lan.cidr}"
              "${netLib.vlanGatewayV6 lan}/64"
            ];
            networkConfig = {
              IPv4Forwarding = true;
              IPv6Forwarding = true;
              IPv6SendRA = true;
            };
            ipv6SendRAConfig = {
              Managed = false;
              OtherInformation = true;
              EmitDNS = true;
              DNS = [ "_link_local" ];
              EmitDomains = true;
              Domains = [ parent.domain ];
            };
            ipv6Prefixes = [
              {
                Prefix = netLib.vlanSubnetV6 lan;
                PreferredLifetimeSec = 1800;
                ValidLifetimeSec = 3600;
              }
            ];
            linkConfig.RequiredForOnline = "no";
          };
          "30-trunk1" = netLib.mkBondChildNetwork "trunk1" "bond0";
          "30-trunk2" = netLib.mkBondChildNetwork "trunk2" "bond0";
          "40-bond0" = {
            matchConfig.Name = "bond0";
            linkConfig = {
              RequiredForOnline = "no";
            };
            networkConfig.LinkLocalAddressing = "no";
            vlan = builtins.map netLib.getVlanInterfaceName (builtins.attrNames vlans);
          };
        }
        // lib.mapAttrs' (
          name: network: lib.nameValuePair "50-vlan-${name}" (mkVlanNetwork name network)
        ) vlans;
      };
    };
}
