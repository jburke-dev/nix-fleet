{
  delib,
  lib,
  config,
  modulesPath,
  ...
}:
delib.host {
  name = "glados";
  system = "x86_64-linux";

  myconfig.boot.mode = "uefi";
  homeManagerSystem = "x86_64-linux";
  home.home.stateVersion = "25.11";

  nixos = {
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    system.stateVersion = "25.11";
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot = {
      initrd = {
        availableKernelModules = [
          "nvme"
          "xhci_pci"
          "thunderbolt"
          "usbhid"
          "usb_storage"
          "sd_mod"
        ];
        kernelModules = [ "dm-snapshot" ];
      };
      kernelModules = [ "kvm-amd" ];
      extraModulePackages = [ ];
    };

    swapDevices = [ ];

    fileSystems."/".neededForBoot = true;

    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
