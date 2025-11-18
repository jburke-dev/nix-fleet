{ delib, ... }:
delib.host {
  name = "colossus";

  myconfig = {
    networking = {
      hostId = "cebaf39d";
      links = {
        lan1 = {
          mac = "98:b7:85:23:63:90";
          priority = 11;
        };
        lan2 = {
          mac = "98:b7:85:23:63:91";
          priority = 11;
        };
      };
      server = {
        bridge = {
          MACAddress = "02:ff:33:9b:15:73";
        };
        bond = {
          enable = true;
        };
      };
    };
  };
}
