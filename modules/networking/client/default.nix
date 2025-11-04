{
  delib,
  host,
  ...
}:
delib.module {
  name = "networking.client";

  options = delib.singleEnableOption (host.isPC || host.installerFeatured);

  nixos.ifEnabled = {
    networking = {
      networkmanager.enable = true;
    };

    user.extraGroups = [ "networkmanager" ];
  };
}
