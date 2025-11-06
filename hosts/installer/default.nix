{
  delib,
  pkgs,
  lib,
  ...
}:
delib.host {
  name = "installer";

  type = "server";

  features = [
    "installer"
  ];

  myconfig = {
    programs.zsh.enable = false;
  };

  nixos = {
    boot.kernelPackages = lib.mkForce pkgs.linuxPackages; # using more stable kernel version to avoid broken zfs kernel errors during build
  };
}
