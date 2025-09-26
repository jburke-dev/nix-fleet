{
  delib,
  ...
}:
delib.host {

  name = "colossus";

  myconfig =
    { myconfig, ... }:
    {
      services = {
        blocky = {
          enable = true;
          listenAddress = "192.168.11.3";
          interface = "vlan-services";
        };
        keepalived = {
          virtualIp = myconfig.constants.traefikVip;
          state = "BACKUP";
        };
      };
    };
}
