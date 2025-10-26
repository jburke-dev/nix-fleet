{ delib, ... }:
delib.host {
  name = "pandora";

  myconfig = {
    disko = {
      enable = true;
      configuration.devices = {
        disk = {
          samsung_990_1tb = {
            type = "disk";
            device = "/dev/disk/by-id/nvme-Samsung_SSD_990_EVO_1TB_S7M3NL0X910980T";
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
        };
      };
    };
  };
}
