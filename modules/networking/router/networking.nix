{ delib, lib, ... }:
delib.module {
  name = "networking.router";

  nixos.ifEnabled =
    { cfg, myconfig, ... }:
    let
      mkEthLink =
        name:
        (mac: {
          matchConfig = {
            Type = "ether";
            MACAddress = mac;
          };
          linkConfig = {
            Name = name;
            # TODO: are RxBufferSize and TxBufferSize necessary?
          };
        });
    in
    {
      systemd.network = {
        enable = true;
        links = lib.mapAttrs' (
          name: linkCfg: lib.nameValuePair "${toString linkCfg.priority}-${name}" (mkEthLink name linkCfg.mac)
        ) cfg.links;
        networks = {

        };
      };
    };
}
