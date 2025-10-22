{ delib, ... }:
delib.host {
  name = "kraken";

  myconfig.services = {
    k3s = {
      clusterInit = true;
    };
  };
}
