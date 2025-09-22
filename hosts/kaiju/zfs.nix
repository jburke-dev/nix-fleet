# TODO: figure out commands
/*
  sudo zpool create \
  -o ashift=12 \
  -o autotrim=on \
  -O compression=zstd \
  -O atime=off \
  -O xattr=sa \
  -O acltype=posixacl \
  -O recordsize=64K \
  -n tank mirror /dev/disk/by-id/ata-Samsung_SSD_860_EVO_2TB_S597NJ0NB23502H /dev/disk/by-id/ata-Samsung_SSD_870_EVO_2TB_S753NS0X525305A mirror /dev/disk/by-id/ata-Samsung_SSD_870_EVO_2TB_S753NS0X525393D /dev/disk/by-id/ata-Samsung_SSD_860_EVO_2TB_S597NJ0NB21852X
*/
{ delib, ... }:
delib.host {
  name = "kaiju";

  nixos = {
    boot = {
      supportedFilesystems = [ "zfs" ];
      zfs.forceImportRoot = false;
    };
  };

}
