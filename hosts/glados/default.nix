{ delib, ... }:
delib.host {
  name = "glados";

  type = "server";

  features = [
    "k3s"
    "amd"
  ];

  myconfig.services.k3s.hasMediaUser = false;
}
