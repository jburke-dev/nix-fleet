{ delib, ... }:
delib.module {
  name = "services.traefik.forgejo";

  options = delib.singleCascadeEnableOption;
  nixos.ifEnabled =
    { myconfig, ... }:
    {
      services.traefik.dynamicConfigOptions.http = {
        services.forgejo.loadBalancer.servers = [
          {
            url = "http://${myconfig.services.forgejo.listenAddress}:${toString myconfig.services.forgejo.httpPort}";
          }
        ];
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
    };
}
