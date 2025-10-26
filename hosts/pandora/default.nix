{ delib, ... }:
delib.host {
  name = "pandora";

  type = "server";

  features = [ "router" ];
}
