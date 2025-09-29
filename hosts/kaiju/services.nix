{
  delib,
  constants,
  ...
}:
let
  listenAddress = "192.168.11.2";
  interface = "vlan-services";
in
delib.host {
  name = "kaiju";

  myconfig.services = {
    blocky = {
      enable = true;
      listenAddress = listenAddress;
      interface = interface;
    };
    keepalived = {
      virtualIp = constants.traefikVip;
      state = "MASTER";
    };
    forgejo = {
      enable = true;
      listenAddress = listenAddress;
      interface = interface;
      stateDir = "/mnt/databases/forgejo";
      domain = "forgejo.apps.chesurah.net";
    };
    glance = {
      enable = true;
      listenAddress = listenAddress;
      interface = interface;
    };
    vaultwarden = {
      enable = true;
      domain = "https://vaultwarden.apps.chesurah.net";
      backupDir = "/mnt/backups/vaultwarden";
      dataDir = "/mnt/databases/vaultwarden";
    };
  };
}
