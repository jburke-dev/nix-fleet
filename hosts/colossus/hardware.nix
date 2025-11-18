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
  home.home.stateVersion = "25.11";

  nixos = {
    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = "25.11";

    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

    boot = {
      initrd = {
        availableKernelModules = [
          "nvme"
          "xhci_pci"
          "mpt3sas"
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

    fileSystems."/".neededForBoot = true;
  };
}
