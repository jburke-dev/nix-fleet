{ delib, ... }:
delib.host {
  name = "colossus";

  nixos = {
    fileSystems."/tank/media" = {
      device = "tank/media";
      fsType = "zfs";
    };
    fileSystems."/data/databases" = {
      device = "data/databases";
      fsType = "zfs";
    };
    fileSystems."/data/cache" = {
      device = "data/cache";
      fsType = "zfs";
    };
  };
}
