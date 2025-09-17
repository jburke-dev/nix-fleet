{ delib, lib, config, modulesPath, ... }:
delib.host {
  name = "desktop";

  system = "x86_64-linux";

  myconfig.boot.mode = "uefi";
  homeManagerSystem = "x86_64-linux";
  home.home.stateVersion = "25.05";

  nixos = {
    system.stateVersion = "25.05";

    imports = [(modulesPath + "/installer/scan/not-detected.nix")];

    boot = {
        initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
        initrd.kernelModules = [];
        kernelModules = [ "kvm-amd" ];
        extraModulePackages = [ ];
    };

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/2f1d6706-d435-4fef-992c-dc9c2c0dca98";
        fsType = "ext4";
      };

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/CB74-BF0B";
        fsType = "vfat";
        options = [ "fmask=0077" "dmask=0077" ];
      };
  
    fileSystems."/mnt/apps" =
      { device = "/dev/disk/by-uuid/e02b8a08-64db-483e-aa5c-922af6bb2fcd";
        fsType = "ext4";
      };
  
    fileSystems."/mnt/data1" =
      { device = "/dev/disk/by-uuid/54d5b68d-f9af-4f91-baa3-abd65fb5b3a9";
        fsType = "btrfs";
      };
  
    fileSystems."/mnt/data2" =
      { device = "/dev/disk/by-uuid/c6354fae-39d5-4d9e-9c08-ce4f05b1a897";
        fsType = "btrfs";
      };

    networking.useDHCP = lib.mkDefault true;
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
