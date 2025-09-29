{
  delib,
  lib,
  pkgs,
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
        enable = true;
        lfs.enable = true;
        stateDir = cfg.stateDir;
        settings = {
          server = {
            DOMAIN = cfg.domain;
            ROOT_URL = "https://${cfg.domain}";
            HTTP_ADDR = cfg.listenAddress;
            HTTP_PORT = cfg.httpPort;
            DISABLE_SSH = true;
          };
          session.COOKIE_SECURE = true;
        };
      };

      networking.firewall = lib.mkIf (cfg.interface != "") {
        interfaces."${cfg.interface}".allowedTCPPorts = [
          cfg.httpPort
        ];
      };
    };
}
