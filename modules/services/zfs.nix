{ delib, host, ... }:
delib.module {
  name = "services.zfs";

  options = delib.singleEnableOption host.zfsFeatured;

  nixos.ifEnabled = {
    boot = {
      supportedFilesystems = [ "zfs" ];
      zfs.forceImportRoot = false;
    };
  };
}
