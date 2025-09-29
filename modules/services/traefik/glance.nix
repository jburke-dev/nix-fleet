{ delib, ... }:
delib.module {
  name = "services.traefik.glance";

  options = delib.singleCascadeEnableOption;

  nixos.ifEnabled.services.traefik.dynamicConfigOptions.http = {
    services.glance.loadBalancer.servers = [ { url = "http://192.168.11.2:8080"; } ];
    routers.glance = {
      rule = "Host(`glance.apps.chesurah.net`)";
      tls.certResolver = "cloudflare";
      entryPoints = [ "https" ];
      service = "glance";
    };
  };
}
