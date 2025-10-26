{
  delib,
  lib,
  pkgs,
  ...
}:
delib.module {
  # TODO: move away from mgmt default gateway?
  name = "networking.systemd";

  options =
    with delib;
    moduleOptions (
      { parent, ... }:
      {
        enable = boolOption (parent.mode == "systemd");

        vlans = attrsOfOption (submodule (
          { config, ... }:
          {
            options = {
              interface = strOption null;
              hostIp = strOption null;
              isDefault = boolOption false;
              metric = intOption 100;
              routingTable = intOption 0;
            };
          }
        )) { };
      }
    );

  nixos.ifEnabled =
    { cfg, myconfig, ... }:
    let
      vlanDefs = myconfig.vlans;
      hostVlans = cfg.vlans;

      # Group VLANs by their physical interface
      vlansByInterface = lib.foldl' (
        acc: name:
        let
          iface = hostVlans.${name}.interface;
        in
        acc
        // {
          ${iface} = (acc.${iface} or [ ]) ++ [ name ];
        }
      ) { } (builtins.attrNames hostVlans);

      mkVlanNetdev = name: {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan-${name}";
        };
        vlanConfig.Id = vlanDefs."${name}".id;
      };

      mkPhysicalNetwork = iface: vlanNames: {
        matchConfig.Name = iface;
        vlan = map (name: "vlan-${name}") vlanNames;
        linkConfig.RequiredForOnline = "no";
        networkConfig.DHCP = "no";
      };

      mkVlanNetwork =
        name: hostCfg:
        let
          inherit (vlanDefs."${name}") subnet;
          fullIp = "${subnet}.${hostCfg.hostIp}";
        in
        {
          matchConfig.Name = "vlan-${name}";
          networkConfig.DHCP = "no";
          address = [ "${fullIp}/24" ];
          linkConfig.RequiredForOnline = "routable";
        }
        // lib.optionalAttrs hostCfg.isDefault {
          routes = [
            {
              Destination = "0.0.0.0/0";
              Gateway = "${subnet}.1";
              Metric = hostCfg.metric;
            }
          ];
        }
        // lib.optionalAttrs (hostCfg.routingTable != 0) {
          routingPolicyRules = [
            {
              From = fullIp;
              Table = hostCfg.routingTable;
              Priority = 110;
            }
            {
              From = "${subnet}.0/24";
              Table = hostCfg.routingTable;
              Priority = 111;
            }
          ];
          routes = [
            {
              Destination = "${subnet}.0/24";
              Scope = "link";
              Table = hostCfg.routingTable;
            }
            {
              Destination = "0.0.0.0/0";
              Gateway = "${subnet}.1";
              Table = hostCfg.routingTable;
              Metric = hostCfg.metric;
            }
          ];
        };
    in
    {
      systemd.network = {
        enable = true;

        netdevs = lib.mapAttrs' (
          name: _: lib.nameValuePair "20-vlan-${name}" (mkVlanNetdev name)
        ) hostVlans;

        networks = lib.mkMerge [
          # Create one network file per physical interface with all its VLANs
          (lib.mapAttrs' (
            iface: vlanNames: lib.nameValuePair "30-${iface}" (mkPhysicalNetwork iface vlanNames)
          ) vlansByInterface)
          # Create one network file per VLAN interface
          (lib.mapAttrs' (
            name: hostCfg: lib.nameValuePair "40-vlan-${name}" (mkVlanNetwork name hostCfg)
          ) hostVlans)
        ];

        wait-online = {
          timeout = 30;
          anyInterface = false;
        };
      };
    };

  home.ifEnabled = {
    home.packages = with pkgs; [
      tcpdump
      conntrack-tools
      traceroute
      tcpdump
    ];
  };

  myconfig.ifEnabled =
    { cfg, myconfig, ... }:
    let
      vlanDefs = myconfig.vlans;
      hostVlans = cfg.vlans;
      getSubnet = vlanName: vlanDefs."${vlanName}".subnet;
    in
    {
      services.hostVlans = builtins.mapAttrs (name: hostCfg: {
        netdevName = "vlan-${name}";
        address = "${getSubnet name}.${hostCfg.hostIp}";
      }) hostVlans;
    };
}
