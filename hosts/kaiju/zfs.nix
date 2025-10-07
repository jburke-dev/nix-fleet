{ delib, ... }:
delib.host {
  name = "kaiju";

  nixos = {
    fileSystems = {
      "/mnt/databases" = {
        device = "tank/databases";
        fsType = "zfs";
      };
      "/mnt/backups" = {
        device = "tank/backups";
        fsType = "zfs";
      };
    };
  };
}
