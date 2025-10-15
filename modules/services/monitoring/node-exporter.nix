{
  delib,
  host,
  lib,
  ...
}:
delib.module {
  name = "services.monitoring.nodeExporter";

  options =
    with delib;
    moduleOptions (
      { parent, ... }:
      {
        enable = boolOption host.isServer;
        listenAddress = strOption parent.listenAddress;
        httpPort = portOption 9100;
        interface = strOption parent.interface;
      }
    );

  nixos.ifEnabled =
    { cfg, ... }:
    {
      services.prometheus.exporters.node = {
        enable = true;
        enabledCollectors = [
          "systemd"
          "processes"
        ];
        port = cfg.httpPort;
        inherit (cfg) listenAddress;
      };

      networking.firewall = lib.mkIf (cfg.interface != "") {
        interfaces."${cfg.interface}".allowedTCPPorts = [
          cfg.httpPort
        ];
      };
    };
}
