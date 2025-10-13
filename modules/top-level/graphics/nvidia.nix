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
      nvidiaPersistenced = true;
      modesetting.enable = true;
      # Use proprietary driver for Pascal (P2200) compatibility
      open = false;
    };
  };
}
