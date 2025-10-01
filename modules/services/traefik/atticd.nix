{ delib, ... }:
delib.module {
  name = "services.traefik.atticd";

  options = delib.singleCascadeEnableOption;

  nixos.ifEnabled.services.traefik.dynamicConfigOptions.http = {
    services.atticd.loadBalancer.servers = [ { url = "http://192.168.11.3:8060"; } ];
    routers.atticd = {
      rule = "Host(`nix-cache.apps.chesurah.net`)";
      tls.certResolver = "cloudflare";
      entryPoints = [ "https" ];
      service = "atticd";
    };
  };
}
