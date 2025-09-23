{
  delib,
  host,
  ...
}:
delib.module {
  name = "networking.client";

  options = delib.singleEnableOption host.isPC;

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
