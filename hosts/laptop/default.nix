{ delib, ... }:
delib.host {
  name = "laptop";

  type = "laptop";
  myconfig.programs = {
    network-utils.enable = true;
    ssh = {
      keyConfigs = [
        {
          host = "github.com";
          identityFileSuffix = "github";
        }
      ];
    };
  };
  rice = "dark";
}
