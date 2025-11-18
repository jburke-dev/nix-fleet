{ delib, lib, ... }:
let
  disksLib = import ../../modules/lib/disks.nix { inherit lib; };
  lvmDisks = {
    samsung_2tb_a = "ata-Samsung_SSD_870_EVO_2TB_S753NS0X526784H";
    samsung_2tb_b = "ata-Samsung_SSD_870_EVO_2TB_S753NS0X532371A";
  };
in
delib.host {
  name = "colossus";

  myconfig = {
    disko = {
      enable = true;
      configuration.devices = {
        disk = {
          crucial_t500_2tb = {
            type = "disk";
            device = "/dev/disk/by-id/nvme-CT2000T500SSD5_2340449E63A3";
            content = {
              type = "gpt";
              partitions = {
                ESP = {
                  size = "1G";
                  type = "EF00";
                  content = {
                    type = "filesystem";
                    format = "vfat";
                    mountpoint = "/boot";
                    mountOptions = [ "umask=0077" ];
                  };
                };
                root = {
                  size = "100%";
                  content = {
                    type = "filesystem";
                    format = "ext4";
                    mountpoint = "/";
                  };
                };
              };
            };
          };
        }
        // (builtins.mapAttrs disksLib.mkLvmPv lvmDisks);
        lvm_vg = {
          mainpool = {
            type = "lvm_vg";
            lvs = {
              storage = {
                size = "100%FREE";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/var/lib/longhorn";
                };
              };
            };
          };
        };
      };
    };
  };
}
