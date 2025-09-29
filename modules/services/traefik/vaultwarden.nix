{ delib, ... }:
delib.module {
  name = "services.traefik.vaultwarden";

  options = delib.singleCascadeEnableOption;

  nixos.ifEnabled.services.traefik.dynamicConfigOptions.http = {
    services.vaultwarden.loadBalancer.servers = [ { url = "http://127.0.0.1:8222"; } ];
    routers.vaultwarden = {
      rule = "Host(`vaultwarden.apps.chesurah.net`)";
      tls.certResolver = "cloudflare";
      entryPoints = [ "https" ];
      service = "vaultwarden";
    };
  };
}
