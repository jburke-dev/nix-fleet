{ delib, host, ... }:
delib.module {
  name = "services.monitoring";

  options =
    with delib;
    moduleOptions (
      { parent, ... }:
      {
        enable = boolOption host.monitoringFeatured;
        listenAddress = readOnly (strOption parent.hostVlans.monitoring.address);
        interface = readOnly (strOption parent.hostVlans.monitoring.netdevName);
      }
    );
}
