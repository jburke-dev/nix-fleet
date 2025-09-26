{ delib, ... }:
delib.module {
  name = "services.traefik.forgejo";

  options = delib.singleCascadeEnableOption;
  nixos.ifEnabled.services.traefik.dynamicConfigOptions.http = {
    # TODO: sync this with forgejo service options?
    services.forgejo.loadBalancer.servers = [ { url = "http://192.168.11.2:3000"; } ];
    routers.forgejo = {
      rule = "Host(`forgejo.apps.chesurah.net`)";
      entryPoints = [ "https" ];
      tls = {
        certResolver = "cloudflare";
        domains = [
          {
            main = "apps.chesurah.net";
            sans = [ "*.apps.chesurah.net" ];
          }
        ];
      };
      service = "forgejo";
    };
  };
}
