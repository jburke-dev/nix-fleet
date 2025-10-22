{
  delib,
  ...
}:
let
  listenAddress = "192.168.11.3";
  interface = "vlan-services";
in
delib.host {

  name = "colossus";

  myconfig =
    { myconfig, ... }:
    {
      services = {
        blocky = {
          enable = true;
          inherit listenAddress interface;
        };
        keepalived = {
          virtualIp = myconfig.constants.traefikVip;
          state = "BACKUP";
        };
        forgejo-runner.enable = true;
        traefik = {
          atticd.enable = false;
        };
        postgres = {
          enable = true;
        };
        /*
          atticd = {
            enable = true;
            listenAddress = listenAddress;
            storageBaseDir = "/data/cache/atticd";
            databaseBaseDir = "/data/databases/atticd";
            interface = interface;
          };
        */
      };
    };
}
