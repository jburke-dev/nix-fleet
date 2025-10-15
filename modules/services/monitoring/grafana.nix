{
  delib,
  lib,
  ...
}:
delib.module {
  name = "services.monitoring.grafana";

  options =
    with delib;
    moduleOptions (
      { parent, ... }:
      {
        enable = boolOption parent.enable;
        listenAddress = strOption parent.listenAddress;
        interface = strOption parent.interface;
        httpPort = portOption 3000;
      }
    );

  nixos.ifEnabled =
    { cfg, myconfig, ... }:
    {
      services.grafana = {
        enable = true;
        settings = {
          server = {
            root_url = "https://grafana.monitoring.chesurah.net";
            http_addr = cfg.listenAddress;
            http_port = cfg.httpPort;
          };
        };

        provision = {
          enable = true;
          datasources.settings.datasources = [
            {
              name = "Prometheus";
              type = "prometheus";
              access = "proxy";
              url = "https://prometheus.monitoring.chesurah.net";
              isDefault = true;
            }
          ];
        };
      };

      networking.firewall = lib.mkIf (cfg.interface != "") {
        interfaces."${cfg.interface}".allowedTCPPorts = [
          cfg.httpPort
        ];
      };
    };
}
