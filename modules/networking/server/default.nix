{ delib, host, ... }:
delib.module {
  name = "networking.server";

  options =
    with delib;
    moduleOptions {
      enable = readOnly (boolOption (host.isServer && !host.routerFeatured));
      interface = submoduleOption {
        options = {
          Name = strOption "";
          Kind = enumOption [ "bond" "bridge" ] "bridge";
          MACAddress = strOption "";
        };
      } { };
    };

  nixos.ifEnabled =
    { parent, cfg, ... }:
    {
      assertions = [
        {
          assertion = cfg.interface.Name != "";
          message = "interface name must not be empty!";
        }
        {
          assertion = cfg.interface.MACAddress != "";
          message = "interface mac must not be empty!";
        }
        {
          assertion = builtins.any (hostname: hostname == host.name) (builtins.attrNames parent.staticHosts);
          message = "servers must have a static reservation setup in the networking module!";
        }
      ];
    };
}
