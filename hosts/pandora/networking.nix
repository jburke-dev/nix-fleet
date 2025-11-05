{ delib, ... }:
delib.host {
  name = "pandora";

  myconfig = {
    networking = {
      hostId = "dabd7000";
      links = {
        trunk1 = {
          mac = "20:7c:14:f8:34:c8";
          priority = 11;
        };
        trunk2 = {
          mac = "20:7c:14:f8:34:c9";
          priority = 12;
        };
        lan1 = {
          mac = "20:7c:14:f8:31:ec";
          priority = 13;
        };
        lan2 = {
          mac = "20:7c:14:f8:31:ed";
          priority = 14;
        };
        lan3 = {
          mac = "20:7c:14:f8:31:ee";
          priority = 15;
        };
        wan = {
          mac = "20:7c:14:f8:31:ef";
          priority = 10;
        };
      };
    };
  };
}
