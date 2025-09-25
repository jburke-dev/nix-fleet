{
  delib,
  ...
}:
delib.module {
  name = "services";

  options =
    with delib;
    moduleOptions {
      enable = boolOption true;
      listenAddress = noDefault (strOption null);
      interface = noDefault (strOption null);
    };

  myconfig.always =
    { cfg, ... }:
    {
      args.nixos = {
        listenAddress = cfg.listenAddress;
        interface = cfg.listenAddress;
      };
    };
}
