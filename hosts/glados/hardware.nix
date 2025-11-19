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
      kernelParams = [
        "ttm.pages_limit=26367190" # 108 GB max allocation, divided by 4KiB page size, see https://www.jeffgeerling.com/blog/2025/increasing-vram-allocation-on-amd-ai-apus-under-linux
        "ttm.page_pool_size=26367190"
      ];
      extraModulePackages = [ ];
    };

    swapDevices = [ ];

    fileSystems."/".neededForBoot = true;

    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
