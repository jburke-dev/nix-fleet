{
  delib,
  config,
  ...
}:
delib.module {
  name = "services.traefik";

  options =
    with delib;
    moduleOptions {
      enable = boolOption false;
      listenAddress = strOption "127.0.0.1";
      interface = strOption "vlan-services";
    };

  nixos.ifEnabled =
    { cfg, ... }:
    {
      services.traefik = {
        enable = true;
        staticConfigOptions = {
          log.level = "WARN";
          api = { };
          entryPoints = {
            http = {
              address = "${cfg.listenAddress}:80";
              http.redirections.entryPoint = {
                to = "https";
                scheme = "https";
              };
            };
            https.address = "${cfg.listenAddress}:443";
          };
          serversTransport.insecureSkipVerify = true;
          certificatesResolvers = {
            cloudflare = {
              acme = {
                email = "jburke.create@gmail.com";
                storage = "/var/lib/traefik/acme.json";
                caServer = "https://acme-v02.api.letsencrypt.org/directory";
                dnsChallenge = {
                  provider = "cloudflare";
                  resolvers = [
                    "1.1.1.1:53"
                    "1.0.0.1:53"
                  ];
                };
              };
            };
          };
        };
        dynamicConfigOptions = {
          http.routers = {
            api = {
              rule = "Host(`traefik-dashboard.mgmt.chesurah.net`)";
              service = "api@internal";
              entrypoints = [ "https" ];
              tls = {
                certResolver = "cloudflare";
                domains = [
                  {
                    main = "mgmt.chesurah.net";
                    sans = [ "*.mgmt.chesurah.net" ];
                  }
                ];
              };
            };
            pfsense = {
              rule = "Host(`pfsense.mgmt.chesurah.net`)";
              entrypoints = [ "https" ];
              tls.certResolver = "cloudflare";
              middlewares = [ "pfsense-headers" ];
            };
            mikrotik = { };
          };
        };
      };

      sops.secrets.cf_dns_api_token.restartUnits = [ "traefik.service" ];

      systemd.services.traefik.serviceConfig = {
        LoadCredential = [
          "cf_dns_api_token:${config.sops.secrets.cf_dns_api_token.path}"
        ];
        Environment = [
          "CF_DNS_API_TOKEN_FILE=%d/cf_dns_api_token"
        ];
      };

      networking.firewall.interfaces."${cfg.interface}".allowedTCPPorts = [
        80
        443
      ];
    };
}
