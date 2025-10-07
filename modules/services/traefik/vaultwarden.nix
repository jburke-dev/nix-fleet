{ delib, ... }:
delib.module {
  name = "services.traefik.vaultwarden";

  options = delib.singleCascadeEnableOption;

  nixos.ifEnabled =
    { myconfig, ... }:
    {
      services.traefik.dynamicConfigOptions.http = {
        services.vaultwarden.loadBalancer.servers = [
          {
            url = "http://${myconfig.services.vaultwarden.listenAddress}:${toString myconfig.services.vaultwarden.httpPort}";
          }
        ];
        routers.vaultwarden = {
          rule = "Host(`vaultwarden.apps.chesurah.net`)";
          tls.certResolver = "cloudflare";
          entryPoints = [ "https" ];
          service = "vaultwarden";
        };
      };
    };
}
