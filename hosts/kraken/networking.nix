{ delib, ... }:
delib.host {
  name = "kraken";

  myconfig = {
    networking = {
      hostId = "daedb04a";
      links = {
        lan3 = {
          mac = "58:47:ca:7d:96:af";
          priority = 11;
        };
        lan4 = {
          mac = "58:47:ca:7d:96:ae";
          priority = 11;
        };
      };
    };
  };
}
