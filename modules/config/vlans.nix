{
  delib,
  ...
}:
delib.module {
  name = "vlans";

  options = with delib; {
    vlans = attrsOfOption (submodule (
      { config, ... }:
      {
        options = {
          id = noDefault (intOption 0);
          subnet = noDefault (strOption "192.168.1");
        };
      }
    )) { };
  };

  myconfig.always =
    { cfg, ... }:
    {
      vlans = {
        mgmt = {
          id = 21;
          subnet = "192.168.21";
        };
        services = {
          id = 11;
          subnet = "192.168.11";
        };
        data = {
          id = 13;
          subnet = "192.168.13";
        };
      };
    };
}
