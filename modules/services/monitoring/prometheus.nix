{
  delib,
  lib,
  ...
}:
delib.module {
  name = "services.monitoring.prometheus";

  options =
    with delib;
    moduleOptions (
      { parent, ... }:
      {
        enable = boolOption parent.enable;
        listenAddress = strOption parent.listenAddress;
        interface = strOption parent.interface;
        httpPort = portOption 9090;
      }
    );

  nixos.ifEnabled =
    { cfg, ... }:
    {
      services.prometheus = {
        enable = true;
        inherit (cfg) listenAddress;
        port = cfg.httpPort;

        scrapeConfigs = [
          {
            job_name = "node";
            static_configs = [
              {
                targets = [ "192.168.15.6:9100" ];
                labels.hostname = "kraken";
              }
              {
                targets = [ "192.168.15.4:9100" ];
                labels.hostname = "colossus";
              }
              {
                targets = [ "192.168.15.5:9100" ];
                labels.hostname = "kaiju";
              }
            ];
          }
        ];
      };

      networking.firewall = lib.mkIf (cfg.interface != "") {
        interfaces."${cfg.interface}".allowedTCPPorts = [
          cfg.httpPort
        ];
      };
    };
}
