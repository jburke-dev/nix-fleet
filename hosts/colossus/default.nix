{
  delib,
  lib,
  pkgs,
  ...
}:
delib.host {
  name = "colossus";

  type = "server";

  features = [
    "nvidia"
    "k3s"
  ];

  myconfig.services.k3s.role = "agent";

  nixos = {
    /*
      use more stable kernel version for zfs support.
      using boot.zfs.package = pkgs.zfs_unstable is an alternative but that risk seems to outweigh the benefit
    */
    boot = {
      kernelPackages = lib.mkForce pkgs.linuxPackages;
      supportedFilesystems = [ "zfs" ];
      zfs = {
        forceImportRoot = false;
        extraPools = [ "tank" ];
      };
    };
  };
}
