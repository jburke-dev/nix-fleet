{ delib, ... }:
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
        };
      };
    };
  };
}
