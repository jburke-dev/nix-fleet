{
  delib,
  lib,
  pkgs,
  ...
}:
delib.module {
  name = "services.postgres";

  options =
    with delib;
    moduleOptions {
      enable = boolOption false;
      dataDir = strOption "/mnt/databases/postgres";
      databases = listOfOption str [ ];
      authentications = listOfOption (submodule {
        options = {
          type = noDefault (enumOption [ "local" "host" ] null);
          database = noDefault (strOption null);
          user = noDefault (strOption null);
          address = strOption "";
          authMethod = noDefault (enumOption [
            "trust"
            "peer"
            "scram-sha-256"
          ]);
          authOptions = attrsOfOption str { };
        };
      }) [ ];
    };

  nixos.ifEnabled =
    { cfg, parent, ... }:
    {
      services.postgresql = {
        enable = true;

        enableTCPIP = true;

        settings = {
          listen_addresses = lib.mkForce parent.hostVlans.data.address;
        };

        inherit (cfg) dataDir;

        identMap = ''
          superuser_map root postgres
          superuser_map postgres postgres
          superuser_map /^(.*)$ \1
        '';

        authentication = lib.mkForce (
          lib.concatMapStringsSep "\n"
            (
              a:
              let
                authOptsStr = lib.concatStringsSep " " (lib.mapAttrsToList (n: v: "${n}=${v}") a.authOptions);
              in
              "${a.type} ${a.database} ${a.user} ${a.address} ${a.authMethod} ${authOptsStr}"
            )
            (
              [
                {
                  type = "local";
                  database = "sameuser";
                  user = "all";
                  authMethod = "peer";
                  address = "";
                  authOptions = {
                    map = "superuser_map";
                  };
                }
              ]
              ++ cfg.authentications
            )
        );

        ensureDatabases = cfg.databases;
        ensureUsers = builtins.map (database: {
          name = database;
          ensureDBOwnership = true;
          ensureClauses.login = true;
        }) cfg.databases;
      };

      networking.firewall.interfaces."${parent.hostVlans.data.netdevName}".allowedTCPPorts = [ 5432 ];
    };
}
