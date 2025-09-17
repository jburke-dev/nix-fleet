{ delib, ... }:
delib.host {
    name = "archetype";

    nixos = {
        nixpkgs.hostPlatform = "x86_64-linux";
        system.stateVersion = "25.05";

        boot = {
            supportedFilesystems = [ "ext4" "btrfs" "xfs" "fat" "vfat" "cifs" "nfs" ];
            kernelModules = [ "kvm-amd" ];

            loader = {
                grub = {
                    enable = true;
                    device = "nodev";
                    efiSupport = true;
                    efiInstallAsRemovable = true;
                };
            };

            initrd = {
                availableKernelModules = [ "9p" "9pnet_virtio" "ata_piix" "uhci_hcd" "virtio_blk" "virtio_mmio" "virtio_net" "virtio_pci" "virtio_scsi" ];
                kernelModules = [ "virtio_balloon" "virtio_console" "virtio_rng" ];
            };

            tmp.cleanOnBoot = true;
        };

        fileSystems."/" = {
            device = "/dev/disk/by-label/nixos";
            autoResize = true;
            fsType = "ext4";
        };

        fileSystems."/boot" = {
            device = "/dev/disk/by-label/ESP";
            fsType = "vfat";
        };

        services.fstrim = {
            enable = true;
            interval = "weekly";
        };
    };
}
