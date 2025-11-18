{ lib, ... }:
with lib;
rec {
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
}
