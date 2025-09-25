{
  delib,
  ...
}:
delib.host {
  name = "kaiju";

  myconfig.services.blocky = {
    enable = true;
    listenAddress = "192.168.11.2";
    interface = "vlan-services";
  };
}
