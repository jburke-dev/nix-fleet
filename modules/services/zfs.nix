{ delib, host, ... }:
delib.module {
  name = "services.zfs";

  options = delib.singleEnableOption host.isServer;

  nixos.ifEnabled = {
    boot = {
      supportedFilesystems = [ "zfs" ];
      zfs.forceImportRoot = false;

    };

    # TODO: make zfs specific mountpoint?
    systemd.tmpfiles.rules = [
      "z /mnt/* 0777 root root - -"
    ];
  };
}
