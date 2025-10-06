{
  delib,
  lib,
  ...
}:
delib.module {
  name = "services.forgejo";

  options =
    with delib;
    moduleOptions {
      enable = boolOption false;
      stateDir = strOption "/var/lib/forgejo";
      listenAddress = strOption "127.0.0.1";
      domain = strOption "localhost";
      httpPort = portOption 3000;
      interface = strOption "";
    };

  nixos.ifEnabled =
    {
      cfg,
      ...
    }:
    {
      services.forgejo = {
        inherit (cfg) stateDir;
        enable = true;
        lfs.enable = true;
        settings = {
          server = {
            DOMAIN = cfg.domain;
            ROOT_URL = "https://${cfg.domain}";
            HTTP_ADDR = cfg.listenAddress;
            HTTP_PORT = cfg.httpPort;
            DISABLE_SSH = true;
          };
          session.COOKIE_SECURE = true;
          actions = {
            ENABLED = true;
            DEFAULT_ACTIONS_URL = "https://data.forgejo.org";
          };
        };
      };

      networking.firewall = lib.mkIf (cfg.interface != "") {
        interfaces."${cfg.interface}".allowedTCPPorts = [
          cfg.httpPort
        ];
      };
    };
}
