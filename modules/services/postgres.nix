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

        authentication = lib.mkOverride 10 ''
          # type | database | user | address | auth-method
          local sameuser all peer map=superuser_map
          host all all 192.168.11.0/24 scram-sha-256
          host all all 192.168.13.0/24 scram-sha-256
          host all all 192.168.30.0/24 scram-sha-256
        '';

        # TODO: ensure users
      };

      networking.firewall.interfaces."${parent.hostVlans.data.netdevName}".allowedTCPPorts = [ 5432 ];
    };
}
