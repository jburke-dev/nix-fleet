{ delib, host, ... }:
delib.module {
  name = "networking.router";

  options =
    with delib;
    moduleOptions {
      enable = readOnly (boolOption host.routerFeatured);
    };
}
