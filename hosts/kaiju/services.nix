{
  delib,
  ...
}:
delib.host {
  name = "kaiju";

  myconfig =
    { myconfig, ... }:
    {
      services = {
        blocky = {
          enable = true;
          listenAddress = "192.168.11.2";
          interface = "vlan-services";
        };
        keepalived = {
          virtualIp = myconfig.constants.traefikVip;
          state = "MASTER";
        };
      };
    };
}
