{ delib, ... }:
delib.host {
  name = "kraken";

  type = "server";
  features = [
    "homeAssistant"
    #"monitoring"
    "k3s"
  ];
  myconfig.networking.nameservers = [
    "192.168.11.2"
    "192.168.11.3"
  ];
}
