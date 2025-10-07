{
  delib,
  constants,
  ...
}:
delib.host {
  name = "kaiju";

  myconfig.services = {
    blocky = {
      enable = true;
    };
    keepalived = {
      virtualIp = constants.traefikVip;
      state = "MASTER";
    };
    traefik = {
      atticd.enable = false;
    };
    forgejo = {
      enable = true;
      stateDir = "/mnt/databases/forgejo";
      domain = "forgejo.apps.chesurah.net";
    };
    postgres = {
      enable = true;
    };
    glance = {
      enable = true;
    };
    vaultwarden = {
      enable = true;
      domain = "https://vaultwarden.apps.chesurah.net";
    };
  };
}
