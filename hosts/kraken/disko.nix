{ delib, ... }:
delib.host {
  name = "kraken";

  myconfig = {
    disko = {
      enable = true;
      configuration.devices = {
        disk = {
          kingston_1tb = {
            type = "disk";
            device = "/dev/disk/by-id/nvme-KINGSTON_OM8PGP41024N-A0_50026B7383A11DD2";
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
          crucial_t700_2tb = {
            type = "disk";
            device = "/dev/disk/by-id/nvme-CT2000T700SSD3_2447E994DECB";
            content = {
              type = "gpt";
              partitions = {
                longhorn = {
                  size = "100%";
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
  };
}
