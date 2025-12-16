{ delib, ... }:
delib.host {
  name = "meerkat";

  myconfig = {
    networking = {
      hostId = "abde403c";
      links = {
        lan1 = {
          mac = "48:21:0b:56:5d:fb";
          priority = 11;
        };
        lan2 = {
          mac = "48:21:0b:57:d7:44";
          priority = 11;
        };
      };
      server = {
        bridge = {
          MACAddress = "02:ed:aa:06:23:87";
        };
      };
    };
  };
}
