{ delib, ... }:
delib.host {
  name = "kaiju";

  type = "server";

  features = [
    "nvidia"
    "k3s"
  ];
}
