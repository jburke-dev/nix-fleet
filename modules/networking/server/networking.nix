{ delib, lib, ... }:
let
  netLib = import ../../lib/networking.nix { inherit lib; };
in
delib.module {
  name = "networking.server";

  nixos.ifEnabled =
    { parent, cfg, ... }:
    {
      systemd.network = {
        enable = true;

        links = lib.mapAttrs' (
          name: linkCfg:
          lib.nameValuePair "${toString linkCfg.priority}-${name}" (netLib.mkEthLink name linkCfg)
        ) parent.links;

        netdevs =
          lib.optionalAttrs cfg.bond.enable {
            "10-${cfg.bond.Name}" = {
              netdevConfig = {
                inherit (cfg.bond) Name;
                Kind = "bond";
              };
              bondConfig = {
                Mode = "802.3ad";
                TransmitHashPolicy = "layer2+3";
              };
            };
          }
          // lib.optionalAttrs cfg.bridge.enable {
            "11-${cfg.bridge.Name}" = {
              netdevConfig = {
                inherit (cfg.bridge) Name MACAddress;
                Kind = "bridge";
              };
              bridgeConfig = {
                STP = true;
                ForwardDelaySec = 4;
                HelloTimeSec = 2;
                MaxAgeSec = 20;
              };
            };
          };

        networks =
          lib.optionalAttrs cfg.bridge.enable {
            "15-${cfg.bridge.Name}" = {
              matchConfig = {
                inherit (cfg.bridge) Name;
              };
              networkConfig.DHCP = "yes";
              linkConfig.RequiredForOnline = "routable";
            };
          }
          // lib.optionalAttrs cfg.bond.enable {
            "12-${cfg.bond.Name}" = {
              matchConfig = {
                inherit (cfg.bond) Name;
              };
              networkConfig = lib.optionalAttrs cfg.bridge.enable {
                Bridge = cfg.bridge.Name;
              };
              linkConfig.RequiredForOnline = "enslaved";
            };
          }
          // lib.mapAttrs' (
            name: _:
            lib.nameValuePair "11-${name}" (
              if cfg.bond.enable then
                (netLib.mkBondChildNetwork name cfg.bond.Name)
              else
                (netLib.mkBridgeNetwork name cfg.bridge.Name)
            )
          ) parent.links;
      };
    };
}
