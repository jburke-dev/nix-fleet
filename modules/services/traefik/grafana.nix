{ delib, ... }:
delib.module {
  name = "services.traefik.grafana";

  options = delib.singleCascadeEnableOption;
  nixos.ifEnabled =
    { myconfig, ... }:
    {
      services.traefik.dynamicConfigOptions.http = {
        services.grafana.loadBalancer.servers = [
          {
            url = "http://192.168.15.6:3000";
          }
        ];
        routers.grafana = {
          rule = "Host(`grafana.monitoring.chesurah.net`)";
          entryPoints = [ "https" ];
          tls = {
            certResolver = "cloudflare";
          };
          service = "grafana";
        };
      };
    };
}
