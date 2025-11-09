{ delib, ... }:
delib.host {
  name = "kraken";

  myconfig = {
    networking = {
      hostId = "daedb04a";
      links = {
        # lan1 and 2 would be SFP+ ports, but the NIC seems to be dead
        lan3 = {
          mac = "58:47:ca:7d:96:af";
          priority = 11;
        };
        lan4 = {
          mac = "58:47:ca:7d:96:ae";
          priority = 11;
        };
      };
      server.interface = {
        Name = "br-lan";
        Kind = "bridge";
        MACAddress = "02:ed:aa:06:23:86";
      };
    };
  };
}
