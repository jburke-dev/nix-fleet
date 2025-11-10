{ delib, ... }:
delib.host {
  name = "glados";

  myconfig = {
    disko = {
      enable = true;
      configuration.devices = {
        disk = {
          samsung_970_2tb = {
            type = "disk";
            device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_2TB_S59CNM0R730285N";
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
          crucial_p3_4tb = {
            type = "disk";
            device = "/dev/disk/by-id/nvme-CT4000P3PSSD8_2325E6E7A261";
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
