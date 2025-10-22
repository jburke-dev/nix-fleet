{ delib, ... }:
delib.host {
  name = "kaiju";

  type = "server";
  features = [
    "reverseProxy"
    "zfs"
    "nvidia"
    "k3s"
  ];
}
