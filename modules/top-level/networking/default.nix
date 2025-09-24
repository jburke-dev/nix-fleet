{
  delib,
  host,
  ...
}:
delib.module {
  name = "networking";

  options =
    with delib;
    moduleOptions {
      enable = boolOption true;
      domain = strOption "infra.chesurah.net";
      nameservers = listOfOption str (
        if host.isPC then
          [
            "192.168.11.2"
          ]
        else
          [
            "1.1.1.1"
            "1.0.0.1"
          ]
      );
      mode = enumOption [ "network-manager" "systemd" ] (
        if host.isPC then "network-manager" else "systemd"
      );
    };

  nixos.ifEnabled =
    { cfg, ... }:
    {
      networking = {
        hostName = host.name;
        firewall.enable = true;
        domain = cfg.domain;
        nameservers = cfg.nameservers;

        useDHCP = false;
        dhcpcd.enable = false;
        useNetworkd = false; # this is just compatibility layer, servers will enable via systemd.network
      };
    };
}
