{ delib, host, ... }:
delib.module {
  name = "networking.server";

  options =
    with delib;
    moduleOptions {
      enable = readOnly (boolOption (host.isServer && !host.routerFeatured && !host.installerFeatured));
      bridge = submoduleOption {
        options = {
          enable = boolOption true;
          Name = strOption "br-lan";
          MACAddress = strOption "";
        };
      } { };
      bond = submoduleOption {
        options = {
          enable = boolOption false;
          Name = strOption "bond0";
        };
      } { };
    };

  myconfig.always =
    { cfg, ... }:
    {
      args.shared = {
        networkInterface = cfg.bridge.Name;
      };
    };

  nixos.ifEnabled =
    { parent, cfg, ... }:
    {
      assertions = [
        {
          assertion = cfg.bridge.enable -> cfg.bridge.Name != "";
          message = "bridge name must not be empty when bridge is enabled!";
        }
        {
          assertion = cfg.bridge.enable -> cfg.bridge.MACAddress != "";
          message = "bridge MAC address must not be empty when bridge is enabled!";
        }
        {
          assertion = cfg.bond.enable -> cfg.bond.Name != "";
          message = "bond name must not be empty when bond is enabled!";
        }
        {
          assertion = builtins.any (hostname: hostname == host.name) (builtins.attrNames parent.staticHosts);
          message = "servers must have a static reservation setup in the networking module!";
        }
      ];
    };
}
