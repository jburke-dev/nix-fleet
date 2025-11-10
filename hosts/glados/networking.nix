{ delib, ... }:
delib.host {
  name = "glados";

  myconfig = {
    networking = {
      hostId = "c9c9daeb";
      links = {
        lan1 = {
          mac = "9c:bf:0d:01:00:41";
          priority = 11;
        };
      };
      server.interface = {
        Name = "br-lan";
        Kind = "bridge";
        MACAddress = "02:c9:96:20:34:72";
      };
    };
  };
}
