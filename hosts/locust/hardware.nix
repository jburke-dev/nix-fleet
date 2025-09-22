{
  delib,
  lib,
  config,
  modulesPath,
  ...
}:
delib.host {
  name = "locust";

  system = "x86_64-linux";

  myconfig.boot.mode = "uefi";
  homeManagerSystem = "x86_64-linux";
  home.home.stateVersion = "25.05";

  nixos = {
    system.stateVersion = "25.05";

    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

    boot = {
      initrd.availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      initrd.kernelModules = [ ];
      kernelModules = [ "kvm-intel" ];
      extraModulePackages = [ ];
    };

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/5d539f96-1d50-4615-b08c-92a0dcb6963e";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/ABB2-9197";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    swapDevices = [ ];
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
