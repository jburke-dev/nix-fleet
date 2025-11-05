{ delib, host, ... }:
delib.module {
  name = "networking.server";

  options =
    with delib;
    moduleOptions {
      enable = readOnly (boolOption host.isServer);
    };
}
