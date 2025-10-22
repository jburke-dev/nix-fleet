{ delib, ... }:
delib.host {
  name = "colossus";

  type = "server";
  features = [
    "reverseProxy"
    "zfs"
    "nvidia"
    "mediaServer"
    "k3s"
  ];
}
