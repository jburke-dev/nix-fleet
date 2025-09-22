{ delib, ... }:
delib.host {
  name = "installer";

  type = "server";

  features = [ "installer" ];
}
