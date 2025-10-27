{ delib, host, ... }:
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
            "192.168.11.3"
          ]
        else
          [
            "1.1.1.1"
            "1.0.0.1"
          ]
      );
    };

  nixos.ifEnabled =
    {
      cfg,
      ...
    }:
    {
      networking = {
        hostName = host.name;
        nftables.enable = true;
        inherit (cfg) domain nameservers;

        # these are covered by nftables
        nat.enable = false;
        firewall.enable = false;

        useDHCP = false;
        dhcpcd.enable = false;
        useNetworkd = false; # this is just the compatibility layer
      };
    };
}
