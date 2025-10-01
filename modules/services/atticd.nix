{
  delib,
  config,
  ...
}:
delib.module {
  name = "services.atticd";

  options =
    with delib;
    moduleOptions {
      enable = boolOption false;
      listenAddress = strOption "127.0.0.1";
      httpPort = portOption 8060;
      storageBaseDir = strOption "/var/lib/atticd/storage";
      databaseBaseDir = strOption "/var/lib/atticd/database";
      interface = strOption "vlan-services";
    };

  nixos.ifEnabled =
    { cfg, ... }:
    {
      sops.secrets.atticd_secret.restartUnits = [ "atticd" ];

      systemd = {
        tmpfiles.settings = {
          "10-atticd" = {
            "${cfg.databaseBaseDir}".Z = {
              user = "atticd";
              group = "atticd";
              mode = "0770";
            };
            "${cfg.storageBaseDir}".Z = {
              user = "atticd";
              group = "atticd";
              mode = "0770";
            };
          };
        };
        services.atticd.serviceConfig.ReadWritePaths = [
          cfg.databaseBaseDir
          cfg.storageBaseDir
        ];
      };
      services.atticd = {
        enable = true;

        environmentFile = config.sops.secrets.atticd_secret.path;
        settings = {
          listen = "${cfg.listenAddress}:${toString cfg.httpPort}";
          allowed-hosts = [ "nix-cache.apps.chesurah.net" ];
          api-endpoint = "https://nix-cache.apps.chesurah.net/";
          jwt = { };
          storage = {
            path = "${cfg.storageBaseDir}";
            type = "local";
          };
          database.url = "sqlite://${cfg.databaseBaseDir}/db.sqlite3?mode=rwc";
        };
      };
      networking.firewall.interfaces."${cfg.interface}".allowedTCPPorts = [ cfg.httpPort ];
    };
}
