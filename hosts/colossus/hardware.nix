{
  delib,
  lib,
  config,
  modulesPath,
  ...
}:
delib.host {
  name = "colossus";

  system = "x86_64-linux";

  myconfig.boot.mode = "uefi";
  homeManagerSystem = "x86_64-linux";
  home.home.stateVersion = "25.05";

  nixos = {
    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = "25.05";

    boot.initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "mpt3sas"
      "ahci"
      "usb_storage"
      "usbhid"
      "sd_mod"
    ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/cfa9e1b7-e246-4dc7-b009-40bd10afb78c";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/80F6-4F24";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    swapDevices = [ ];

    networking.useDHCP = lib.mkDefault true;

    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
