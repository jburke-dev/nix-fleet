{ delib, ... }:
delib.module {
  name = "services.traefik.media";

  options = delib.singleCascadeEnableOption;
  nixos.ifEnabled =
    let
      mediaServerIp = "192.168.11.3";
      ports = {
        jellyfin = "8096";
        deluge = "8112";
        sonarr = "8989";
        prowlarr = "9696";
        radarr = "7878";
      };
    in
    { myconfig, ... }:
    {
      services.traefik.dynamicConfigOptions.http = {
        services = {
          jellyfin.loadBalancer.servers = [
            {
              url = "http://${mediaServerIp}:${ports.jellyfin}";
            }
          ];
          deluge.loadBalancer.servers = [
            {
              url = "http://${mediaServerIp}:${ports.deluge}";
            }
          ];
          sonarr.loadBalancer.servers = [
            {
              url = "http://${mediaServerIp}:${ports.sonarr}";
            }
          ];
          prowlarr.loadBalancer.servers = [
            {
              url = "http://${mediaServerIp}:${ports.prowlarr}";
            }
          ];
          radarr.loadBalancer.servers = [
            {
              url = "http://${mediaServerIp}:${ports.radarr}";
            }
          ];
        };
        routers = {
          jellyfin = {
            rule = "Host(`jellyfin.apps.chesurah.net`)";
            entryPoints = [ "https" ];
            tls = {
              certResolver = "cloudflare";
            };
            service = "jellyfin";
          };
          deluge = {
            rule = "Host(`deluge.apps.chesurah.net`)";
            entryPoints = [ "https" ];
            tls = {
              certResolver = "cloudflare";
            };
            service = "deluge";
          };
          sonarr = {
            rule = "Host(`sonarr.apps.chesurah.net`)";
            entryPoints = [ "https" ];
            tls = {
              certResolver = "cloudflare";
            };
            service = "sonarr";
          };
          radarr = {
            rule = "Host(`radarr.apps.chesurah.net`)";
            entryPoints = [ "https" ];
            tls = {
              certResolver = "cloudflare";
            };
            service = "radarr";
          };
          prowlarr = {
            rule = "Host(`prowlarr.apps.chesurah.net`)";
            entryPoints = [ "https" ];
            tls = {
              certResolver = "cloudflare";
            };
            service = "prowlarr";
          };
        };
      };
    };
}
