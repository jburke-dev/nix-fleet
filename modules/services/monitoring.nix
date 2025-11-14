{ delib, host, ... }:
delib.module {
  name = "services.monitoring";

  options = delib.singleEnableOption (host.isServer && !host.k3sFeatured);

  nixos.ifEnabled = {
    services = {
      prometheus.exporters.node = {
        enable = true;
        listenAddress = "10.10.0.1";
      };
    };
  };
}
