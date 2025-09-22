{
  delib,
  host,
  lib,
  ...
}:
delib.module {
  name = "networking";

  options =
    with delib;
    moduleOptions {
      enable = boolOption true;

      nameServers = listOfOption str (
        if host.isPC then
          [
            "192.168.10.10"
            "192.168.10.22"
          ]
        else
          [
            "1.1.1.1"
            "1.0.0.1"
          ]
      );
    };

  nixos.ifEnabled =
    { cfg, ... }:
    {
      networking = {
        hostName = host.name;

        firewall.enable = true;

        useDHCP = lib.mkDefault host.dhcpClientFeatured;
        dhcpcd = lib.mkIf (host.dhcpClientFeatured) {
          enable = true;
          extraConfig = "nohook resolv.conf";
        };

        networkmanager = lib.mkIf (host.isPC) {
          enable = true;
          dns = "none";
        };

        nameservers = cfg.nameServers;
        domain = "infra.chesurah.net";
      };

      user.extraGroups = lib.mkIf (host.isPC) [ "networkmanager" ];
    };
}
