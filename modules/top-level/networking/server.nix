{
  delib,
  host,
  ...
}:
delib.module {
  name = "networking.server";

  options = delib.singleEnableOption host.isServer;

  nixos.ifEnabled.systemd.network.enable = true;
}
