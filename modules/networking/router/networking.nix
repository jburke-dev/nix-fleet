{ delib, lib, ... }:
let
  netLib = import ../../lib/networking.nix { inherit lib; };
in
delib.module {
  name = "networking.router";

  nixos.ifEnabled =
    { parent, ... }:
    let
      bridgeName = "br-lan";
      mkVlanNetdev =
        name:
        (id: {
          netdevConfig = {
            Name = netLib.getVlanInterfaceName name;
            Kind = "vlan";
          };
          vlanConfig.Id = id;
        });
      mkVlanNetwork =
        name:
        (
          { id, cidr, ... }@vlan:
          {
            matchConfig = netLib.getVlanInterfaceName name;
            address = [
              # TODO: what ipv6 prefix to use for ula?
              "${netLib.vlanIp vlan "0.1"}/${vlan.cidr}"
            ];
            networkConfig = {
              IPv6AcceptRA = false;
            };
          }
        );
      mkBridgeNetwork = name: {
        matchConfig.Name = name;
        networkConfig = {
          Bridge = bridgeName;
        };
        linkConfig.RequiredForOnline = "enslaved";
        bridgeConfig = {
          HairPin = false;
          FastLeave = true;
          Cost = 4;
        };
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
          name: id: lib.nameValuePair "20-vlan-${name}" (mkVlanNetdev name id)
        ) parent.vlans;
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
          "11-lan1" = mkBridgeNetwork "lan1";
          "11-lan2" = mkBridgeNetwork "lan2";
          "11-lan3" = mkBridgeNetwork "lan3";
          "15-${bridgeName}" = {
            matchConfig.Name = bridgeName;
            address = [ "10.10.0.1/24" ];
            networkConfig = {
              IPv4Forwarding = true;
              IPv6Forwarding = false;
            };
            linkConfig.RequiredForOnline = "no";
          };
          "30-trunk1" = {
            matchConfig.Name = "trunk1";
            networkConfig.Bond = "bond0";
            linkConfig.RequiredForOnline = "enslaved";
          };
          "30-trunk2" = {
            matchConfig.Name = "trunk2";
            networkConfig.Bond = "bond0";
            linkConfig.RequiredForOnline = "enslaved";
          };
          "40-bond0" = {
            matchConfig.Name = "bond0";
            linkConfig = {
              RequiredForOnline = "no";
            };
            networkConfig.LinkLocalAddressing = "no";
            vlan = builtins.map netLib.getVlanInterfaceName (builtins.attrNames parent.vlans);
          };
        }
        // lib.mapAttrs' (name: id: lib.nameValuePair "50-vlan-${name}" (mkVlanNetwork name id));
      };
    };
}
