{ delib, ... }:
delib.host {
  name = "colossus";

  nixos = {
    fileSystems = {
      "/mnt/media" = {
        device = "tank/media";
        fsType = "zfs";
      };
      "/mnt/cache" = {
        device = "data/cache";
        fsType = "zfs";
      };
      "/mnt/databases" = {
        device = "data/databases";
        fsType = "zfs";
      };
    };
  };
}
