{ delib, ... }:
delib.host {
  name = "kaiju";

  myconfig = {
    networking = {
      hostId = "cbefa93c";
      links = {
        lan1 = {
          mac = "1a:4b:23:16:71:5a";
          priority = 11;
        };
        lan2 = {
          mac = "1a:4b:23:16:71:5b";
          priority = 11;
        };
      };
      server.interface = {
        Name = "bond0";
        Kind = "bond";
        MACAddress = "02:fe:3d:da:12:9a";
      };
    };
  };
}
