{ delib, ... }:
delib.host {
  name = "kaiju";

  nixos = {
    fileSystems."/mnt/databases" = {
      device = "tank/databases";
      fsType = "zfs";
    };
    fileSystems."/mnt/backups" = {
      device = "tank/backups";
      fsType = "zfs";
    };
  };
}
