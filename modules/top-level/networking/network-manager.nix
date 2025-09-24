{
  delib,
  ...
}:
delib.module {
  name = "networking.network-manager";

  options =
    with delib;
    moduleOptions (
      { parent, ... }:
      {
        enable = boolOption (parent.mode == "network-manager");
      }
    );

  nixos.ifEnabled = {
    networking = {
      networkmanager = {
        enable = true;
        dns = "none";
      };
    };

    user.extraGroups = [ "networkmanager" ];
  };
}
