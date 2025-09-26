{
  delib,
  ...
}:
# TODO: configure more!  caching, logging, prometheus exporter...
delib.module {
  name = "services.blocky";

  options =
    with delib;
    moduleOptions {
      enable = boolOption false;
      upstreamAddresses = listOfOption str [
        "1.1.1.1"
        "1.0.0.1"
      ];
      listenAddress = strOption "127.0.0.1";
      interface = strOption "vlan-services";
    };

  nixos.ifEnabled =
    { cfg, ... }:
    {
      services.blocky = {
        enable = true;
        settings = {
          ports = {
            dns = [
              "127.0.0.1:53"
              "${cfg.listenAddress}:53"
            ];
            http = [
              "127.0.0.1:4000"
              "${cfg.listenAddress}:4000"
            ];
          };
          upstreams.groups.default = cfg.upstreamAddresses;
          blocking = {
            denylists.ads = [ "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts" ];
            clientGroupsBlock.default = [ "ads" ];
          };
          customDNS.mapping = {
            "mgmt.chesurah.net" = "192.168.11.10";
            "apps.chesurah.net" = "192.168.11.2";
            "kaiju.infra.chesurah.net" = "192.168.21.5";
            "colossus.infra.chesurah.net" = "192.168.21.4";
          };
        };
      };

      networking.firewall.interfaces."${cfg.interface}" = {
        allowedTCPPorts = [
          53
          4000
        ];
        allowedUDPPorts = [ 53 ];
      };
    };
}
