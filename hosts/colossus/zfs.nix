{ delib, ... }:
delib.host {
  name = "colossus";

  nixos = {
    fileSystems = {
      "/mnt/media" = {
        device = "tank/media";
        fsType = "zfs";
      };
      "/mnt/data/cache" = {
        device = "data/cache";
        fsType = "zfs";
      };
      "/mnt/data/databases" = {
        device = "data/databases";
        fsType = "zfs";
      };
    };
  };
}
