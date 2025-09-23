{
  delib,
  ...
}:
# TODO: configure more!  caching, logging, prometheus exporter...
delib.host {
  name = "kaiju";
  nixos.services.blocky = {
    enable = true;
    settings = {
      ports = {
        dns = [
          "192.168.11.2:53"
          "127.0.0.1:53"
        ];
        http = [
          "192.168.11.2:4000"
          "127.0.0.1:4000"
        ];
      };
      upstreams.groups.default = [
        "1.1.1.1"
        "1.0.0.1"
      ];
      blocking = {
        denylists.ads = [ "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts" ];
        clientGroupsBlock.default = [ "ads" ];
      };
    };
  };
}
