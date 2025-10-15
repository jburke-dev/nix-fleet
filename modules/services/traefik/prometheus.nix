{ delib, ... }:
delib.module {
  name = "services.traefik.prometheus";

  options = delib.singleCascadeEnableOption;
  nixos.ifEnabled =
    { myconfig, ... }:
    {
      services.traefik.dynamicConfigOptions.http = {
        services.prometheus.loadBalancer.servers = [
          {
            url = "http://192.168.15.6:9090";
          }
        ];
        routers.prometheus = {
          rule = "Host(`prometheus.monitoring.chesurah.net`)";
          entryPoints = [ "https" ];
          tls = {
            certResolver = "cloudflare";
            domains = [
              {
                main = "monitoring.chesurah.net";
                sans = [ "*.monitoring.chesurah.net" ];
              }
            ];
          };
          service = "prometheus";
        };
      };
    };
}
