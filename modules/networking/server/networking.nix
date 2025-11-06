{ delib, lib, ... }:
let
  netLib = import ../../lib/networking.nix { inherit lib; };
in
delib.module {
  name = "networking.server";

  nixos.ifEnabled =
    { parent, ... }:
    {
      systemd.network = {
        enable = true;

        links = lib.mapAttrs' (
          name: linkCfg:
          lib.nameValuePair "${toString linkCfg.priority}-${name}" (netLib.mkEthLink name linkCfg)
        ) parent.links;
        # TODO: make this handle device specific configs
        networks = {
          "11-lan3" = {
            matchConfig.Name = "lan3";
            networkConfig.DHCP = "yes";
            linkConfig.RequiredForOnline = "no";
          };
          "11-lan4" = {
            matchConfig.Name = "lan4";
            networkConfig.DHCP = "yes";
            linkConfig.RequiredForOnline = "routable";
          };
        };
      };
    };
}
