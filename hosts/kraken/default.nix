{ delib, ... }:
delib.host {
  name = "kraken";

  type = "server";

  features = [
    "k3s"
    "forgejoRunner"
  ];
}
