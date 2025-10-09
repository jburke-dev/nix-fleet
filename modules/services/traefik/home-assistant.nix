{ delib, ... }:
delib.module {
  name = "services.traefik.home-assistant";

  options = delib.singleCascadeEnableOption;

  nixos.ifEnabled =
    { myconfig, parent, ... }:
    {
      services.traefik.dynamicConfigOptions.http = {
        services.home-assistant.loadBalancer.servers = [
          {
            url = parent.serviceUrls.homeAssistant;
          }
        ];
        routers.home-assistant = {
          rule = "Host(`home-assistant.apps.chesurah.net`)";
          tls.certResolver = "cloudflare";
          entryPoints = [ "https" ];
          service = "home-assistant";
        };
      };
    };
}
