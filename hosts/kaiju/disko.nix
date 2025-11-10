{ delib, ... }:
let
  mkLvmPv = _: devId: {
    type = "disk";
    device = "/dev/disk/by-id/${devId}";
    content = {
      type = "gpt";
      partitions = {
        primary = {
          size = "100%";
          content = {
            type = "lvm_pv";
            vg = "mainpool";
          };
        };
      };
    };
  };
  lvmDisks = {
    samsung_2tb_a = "ata-Samsung_SSD_870_EVO_2TB_S753NS0X525305A";
    samsung_2tb_b = "ata-Samsung_SSD_870_EVO_2TB_S753NS0X525393D";
    samsung_2tb_c = "ata-Samsung_SSD_860_EVO_2TB_S597NJ0NB23502H";
    samsung_2tb_d = "ata-Samsung_SSD_860_EVO_2TB_S597NJ0NB21852X";
  };
in
delib.host {
  name = "kaiju";

  myconfig = {
    disko = {
      enable = true;
      configuration.devices = {
        disk = {
          crucial_2tb = {
            type = "disk";
            device = "/dev/disk/by-id/nvme-CT2000T500SSD5_2340449E6841";
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
        // (builtins.mapAttrs mkLvmPv lvmDisks);
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
