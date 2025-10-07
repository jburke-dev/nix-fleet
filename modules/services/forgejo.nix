{
  delib,
  lib,
  ...
}:
delib.module {
  name = "services.forgejo";

  options =
    with delib;
    moduleOptions (
      { parent, ... }:
      {
        enable = boolOption false;
        stateDir = strOption "/var/lib/forgejo";
        listenAddress = strOption parent.hostVlans.services.address;
        domain = strOption "localhost";
        httpPort = portOption 3000;
        interface = strOption parent.hostVlans.services.netdevName;
      }
    );

  nixos.ifEnabled =
    {
      cfg,
      ...
    }:
    {
      services.forgejo = {
        inherit (cfg) stateDir;
        enable = true;
        database = {
          type = "postgres";
        };
        lfs.enable = true;
        settings = {
          server = {
            DOMAIN = cfg.domain;
            ROOT_URL = "https://${cfg.domain}";
            HTTP_ADDR = cfg.listenAddress;
            HTTP_PORT = cfg.httpPort;
            DISABLE_SSH = true; # FIXME
          };
          session.COOKIE_SECURE = true;
          actions = {
            ENABLED = true;
            DEFAULT_ACTIONS_URL = "https://data.forgejo.org";
          };
        };
      };

      # recommended in https://github.com/NixOS/nixpkgs/issues/423795
      # but couldn't get this to work
      # according to archwiki this also needs UsePAM = true
      /*
        systemd.sockets.forgejo = {
          requiredBy = [ "forgejo.service" ];
          wantedBy = [ "sockets.target" ];

          listenStreams = [
            "22"
          ];
        };
      */

      networking.firewall = lib.mkIf (cfg.interface != "") {
        interfaces."${cfg.interface}".allowedTCPPorts = [
          cfg.httpPort
        ];
      };
    };
}
