{ delib, ... }:
delib.host {
  name = "pandora";

  type = "server";

  features = [ "router" ];

  nixos = {
    services = {
      prometheus.exporters.node = {
        enable = true;
        listenAddress = "10.10.0.1";
      };
    };
  };
}
