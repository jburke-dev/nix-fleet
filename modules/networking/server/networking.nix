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
        netdevs = {
          "10-${cfg.interface.Name}" = {
            netdevConfig = {
              inherit (cfg.interface) Name Kind MACAddress;
            };
          }
          // lib.optionalAttrs (cfg.interface.Kind == "bridge") {
            bridgeConfig = {
              STP = true;
              ForwardDelaySec = 4;
              HelloTimeSec = 2;
              MaxAgeSec = 20;
            };
          }
          // lib.optionalAttrs (cfg.interface.Kind == "bond") {
            bondConfig = {
              Mode = "802.3ad";
              TransmitHashPolicy = "layer2+3";
            };
          };
        };
        networks = {
          "15-${cfg.interface.Name}" = {
            matchConfig = { inherit (cfg.interface) Name; };
            networkConfig.DHCP = "yes";
            linkConfig.RequiredForOnline = "routable";
          };
        }
        // lib.mapAttrs' (
          name: _:
          lib.nameValuePair "11-${name}" (
            if cfg.interface.Kind == "bridge" then
              (netLib.mkBridgeNetwork name cfg.interface.Name)
            else
              (netLib.mkBondChildNetwork name cfg.interface.Name)
          )
        ) parent.links;
      };
    };
}
