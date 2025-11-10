{ delib, host, ... }:
delib.module {
  name = "networking.router";

  options =
    with delib;
    moduleOptions {
      enable = readOnly (boolOption host.routerFeatured);
      # TODO: these are assumed to be tcp for now
      privilegedPorts = readOnly (
        attrsOfOption port {
          ssh = 22;
          dhcp4ControlHttp = 8000;
          dhcp6ControlHttp = 8001;
        }
      );
    };
}
