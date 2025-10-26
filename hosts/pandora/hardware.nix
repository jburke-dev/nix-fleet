{
  delib,
  lib,
  config,
  modulesPath,
  ...
}:
delib.host {
  name = "pandora";

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
          "xhci_pci"
          "nvme"
          "usb_storage"
          "usbhid"
          "sd_mod"
          "sdhci_pci"
        ];
        kernelModules = [ ];
      };
      kernelModules = [ "kvm-intel" ];
      extraModulePackages = [ ];
    };
    fileSystems."/".neededForBoot = true;
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
