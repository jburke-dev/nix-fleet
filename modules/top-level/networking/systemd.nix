{
  delib,
  ...
}:
delib.module {
  name = "networking.systemd";

  options =
    with delib;
    moduleOptions (
      { parent, ... }:
      {
        enable = boolOption (parent.mode == "systemd");
      }
    );

  nixos.ifEnabled.systemd.network.enable = true;
}
