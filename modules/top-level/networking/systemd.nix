{
  delib,
  lib,
  ...
}:
delib.module {
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

      mkVlanNetdev = name: {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan-${name}";
        };
        vlanConfig.Id = vlanDefs."${name}".id;
      };

      mkPhysicalNetwork = name: hostCfg: {
        matchConfig.Name = hostCfg.interface;
        vlan = [ "vlan-${name}" ];
        linkConfig.RequiredForOnline = if hostCfg.isDefault then "carrier" else "no";
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
          linkConfig.RequiredForOnline = if hostCfg.isDefault then "yes" else "no";
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
          (lib.mapAttrs' (
            name: hostCfg: lib.nameValuePair "30-${hostCfg.interface}-${name}" (mkPhysicalNetwork name hostCfg)
          ) hostVlans)
          (lib.mapAttrs' (
            name: hostCfg: lib.nameValuePair "40-vlan-${name}" (mkVlanNetwork name hostCfg)
          ) hostVlans)
        ];

        wait-online = {
          timeout = 30;
          anyInterface = true;
        };
      };
    };
}
