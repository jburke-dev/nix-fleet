{
  delib,
  listenAddress,
  interface,
  ...
}:
delib.module {
  name = "services.traefik";

  options =
    with delib;
    moduleOptions {
      enable = boolOption false;
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
              address = "${listenAddress}:80";
              http.redirections.entryPoint = {
                to = "websecure";
                scheme = "https";
              };
            };
            https.address = "${listenAddress}:443";
          };
          serversTransport.insecureSkipVerify = true;
          certificatesResolvers = {
            cloudflare = {
              acme = {
                email = "jburke.create@gmail.com";
                storage = "/var/lib/traefik/acme.json";
                caServer = "https://acme-staging-v02.api.letsencrypt.org/directory";
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
      };

      systemd.services.traefik.serviceConfig = {
        EnvironmentFile = [ "/var/lib/traefik/env" ]; # TODO: secret management
      };

      networking.firewall."${interface}".allowedTCPPorts = [
        80
        443
      ];
    };
}
