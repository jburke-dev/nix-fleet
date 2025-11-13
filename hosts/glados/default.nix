{ delib, ... }:
delib.host {
  name = "glados";

  type = "server";

  features = [ "k3s" ];
}
