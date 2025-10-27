{ delib, host, ... }:
delib.module {
  name = "networking.router";

  options =
    with delib;
    moduleOptions {
      enable = boolOption host.routerFeatured;
      links = attrsOfOption (submodule {
        options = {
          mac = strOption "";
          priority = intOption 10;
        };
      }) { };
    };

  nixos.ifEnabled = {
    networking.hostId = "dabd7000";
  };
}
