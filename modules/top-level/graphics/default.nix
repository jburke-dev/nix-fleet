{
  delib,
  ...
}:
delib.module {
  name = "graphics";

  options = delib.singleEnableOption true;

  nixos.ifEnabled.hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
