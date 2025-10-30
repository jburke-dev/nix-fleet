{ delib, host, ... }:
delib.module {
  name = "networking.router";

  options =
    with delib;
    moduleOptions {
      enable = boolOption host.routerFeatured;
    };
}
