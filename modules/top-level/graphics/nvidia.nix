{
  delib,
  host,
  ...
}:
delib.module {
  name = "graphics.nvidia";

  options = delib.singleEnableOption host.nvidiaFeatured;

  nixos.ifEnabled = {
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      nvidiaSettings = false;
      modesetting.enable = true;
      open = true;
    };
  };
}
