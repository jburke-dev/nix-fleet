{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "graphics.amd";

  options = delib.singleEnableOption host.amdFeatured;

  nixos.ifEnabled = {
    hardware.amdgpu.opencl.enable = true;

    environment.systemPackages = with pkgs; [
      rocmPackages.rocm-smi
      rocmPackages.rocminfo
      rocmPackages.clr
    ];
  };
}
