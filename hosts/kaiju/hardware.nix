{
  delib,
  lib,
  config,
  modulesPath,
  ...
}:
delib.host {
  name = "kaiju";

  system = "x86_64-linux";

  myconfig.boot.mode = "uefi";
  homeManagerSystem = "x86_64-linux";
  home.home.stateVersion = "25.05";

  nixos = {
    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = "25.05";

    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

    boot = {
      initrd = {
        availableKernelModules = [
          "nvme"
          "xhci_pci"
          "ahci"
          "usbhid"
          "usb_storage"
          "sd_mod"
        ];
        kernelModules = [ ];
      };
      kernelModules = [ "kvm-amd" ];
      extraModulePackages = [ ];
    };

    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/1117eabd-7824-485c-9970-46fdd08443e4";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/FE0D-B598";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
  };
}
