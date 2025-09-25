{
  delib,
  ...
}:
delib.module {
  name = "services.traefik.external-services";

  options = delib.singleCascadeEnableOption;

  nixos.ifEnabled.services.traefik.dynamicConfigOptions.http = {
    services = {
      pfsense.loadBalancer = {
        passHostHeader = true;
        serversTransport = "pfsense";
        servers = [
          {
            url = "https://192.168.21.1";
          }
        ];
      };
      mikrotik.loadBalancer.servers = [ { url = "http://192.168.21.3"; } ];
    };
    routers = {
      pfsense = {
        rule = "Host(`pfsense.mgmt.chesurah.net`)";
        entryPoints = [ "https" ];
        tls.certResolver = "cloudflare";
        service = "pfsense";
        middlewares = [ "pfsense-headers" ];
      };
      mikrotik = {
        rule = "Host(`mikrotik.mgmt.chesurah.net`)";
        entryPoints = [ "https" ];
        tls.certResolver = "cloudflare";
        service = "mikrotik";
      };
    };
    middlewares.pfsense-headers.headers.customRequestHeaders."X-Forwarded-Proto" = "https";
    serversTransports.pfsense.insecureSkipVerify = true;
  };
}
