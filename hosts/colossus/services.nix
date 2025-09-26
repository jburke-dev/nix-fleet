{
  delib,
  ...
}:
delib.host {

  name = "colossus";

  myconfig.services = {
    blocky = {
      enable = true;
      listenAddress = "192.168.11.3";
      interface = "vlan-services";
    };
  };
}
