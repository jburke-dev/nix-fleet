{
  delib,
  lib,
  config,
  modulesPath,
  ...
}:
delib.host {
  name = "meerkat";

  system = "x86_64-linux";

  myconfig.boot.mode = "uefi";
  homeManagerSystem = "x86_64-linux";
  home.home.stateVersion = "26.05";

  nixos = {
    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = "26.05";

    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

    boot = {
      initrd = {
        availableKernelModules = [
          "nvme"
          "xhci_pci"
          "usbhid"
          "usb_storage"
          "sd_mod"
          "thunderbolt"
          "ahci"
        ];
        kernelModules = [ ];
      };
      kernelModules = [ "kvm-intel" ];
      extraModulePackages = [ ];
    };

    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    fileSystems."/".neededForBoot = true;
  };
}
