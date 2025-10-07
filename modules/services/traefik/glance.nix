{ delib, ... }:
delib.module {
  name = "services.traefik.glance";

  options = delib.singleCascadeEnableOption;

  nixos.ifEnabled =
    { myconfig, ... }:
    {
      services.traefik.dynamicConfigOptions.http = {
        services.glance.loadBalancer.servers = [
          {
            url = "http://${myconfig.services.glance.listenAddress}:${toString myconfig.services.glance.httpPort}";
          }
        ];
        routers.glance = {
          rule = "Host(`glance.apps.chesurah.net`)";
          tls.certResolver = "cloudflare";
          entryPoints = [ "https" ];
          service = "glance";
        };
      };
    };
}
