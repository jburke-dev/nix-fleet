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
      inherit listenAddress interface;
    };
    keepalived = {
      virtualIp = constants.traefikVip;
      state = "MASTER";
    };
    traefik = {
      atticd.enable = false;
      forgejo.enable = false;
    };
    forgejo = {
      enable = false;
      inherit listenAddress interface;
      stateDir = "/mnt/databases/forgejo";
      domain = "forgejo.apps.chesurah.net";
    };
    glance = {
      enable = true;
      inherit listenAddress interface;
    };
    vaultwarden = {
      enable = true;
      domain = "https://vaultwarden.apps.chesurah.net";
      backupDir = "/mnt/backups/vaultwarden";
      dataDir = "/mnt/databases/vaultwarden";
    };
  };
}
