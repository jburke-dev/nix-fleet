{
  delib,
  listenAddress,
  interface,
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
              "${listenAddress}:53"
            ];
            http = [
              "127.0.0.1:4000"
              "${listenAddress}:4000"
            ];
          };
          upstreams.groups.default = cfg.upstreamAddresses;
          blocking = {
            denylists.ads = [ "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts" ];
            clientGroupsBlock.default = [ "ads" ];
          };
          customDNS.mapping = {
            "internal.chesurah.net" = "192.168.20.10";
          };
        };
      };

      networking.firewall."${interface}" = {
        allowedTCPPorts = [
          53
          4000
        ];
        allowedUDPPorts = [ 53 ];
      };
    };
}
