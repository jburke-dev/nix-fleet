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
    moduleOptions {
      enable = boolOption false;
      listenAddress = strOption "127.0.0.1";
      dataDir = strOption "/var/lib/vaultwarden";
      backupDir = strOption "/var/backup/vaultwarden";
      domain = strOption "localhost";
      httpPort = portOption 8222;
      interface = strOption "";
    };

  nixos.ifEnabled =
    {
      cfg,
      ...
    }:
    {
      services.vaultwarden = {
        enable = true;
        inherit (cfg) backupDir;
        config = {
          #DATA_FOLDER = cfg.dataDir;
          ROCKET_ADDRESS = cfg.listenAddress;
          ROCKET_PORT = cfg.httpPort;
          DOMAIN = cfg.domain;
          SIGNUPS_ALLOWED = true;
        };
      };

      systemd.tmpfiles.settings = {
        "11-vaultwarden".${cfg.dataDir}.d = {
          user = "vaultwarden";
          group = "vaultwarden";
          mode = "0770";
        };
      };

      networking.firewall.allowedTCPPorts = [ cfg.httpPort ];
    };
}
