{
  delib,
  lib,
  pkgs,
  ...
}:
delib.module {
  name = "services.vaultwarden";

  options =
    with delib;
    moduleOptions (
      { parent, ... }:
      {
        enable = boolOption false;
        listenAddress = strOption "127.0.0.1"; # vaultwarden won't listen over http on non-localhost
        domain = allowNull (strOption null);
        httpPort = portOption 8222;
      }
    );

  nixos.ifEnabled =
    {
      cfg,
      ...
    }:
    {
      services.vaultwarden = {
        enable = true;
        dbBackend = "postgresql";
        config = {
          DATABASE_URL = "postgresql://vaultwarden@/vaultwarden?host=/run/postgresql";
          ROCKET_ADDRESS = cfg.listenAddress;
          ROCKET_PORT = cfg.httpPort;
          DOMAIN = cfg.domain;
          SIGNUPS_ALLOWED = true;
        };
      };

      networking.firewall.allowedTCPPorts = [ cfg.httpPort ];
    };

  myconfig.ifEnabled =
    { cfg, ... }:
    {
      services.postgres = {
        databases = [ "vaultwarden" ];
      };
    };
}
