{
  delib,
  lib,
  host,
  staticHosts,
  domain,
  ...
}:
delib.module {
  name = "services.k3s.server";

  options =
    with delib;
    moduleOptions (
      { parent, ... }:
      {
        enable = boolOption (parent.role == "server");
        clusterInit = boolOption (host.name == parent.bootstrapHost);
        kubeVip = strOption "10.12.1.100";
      }
    );

  nixos.ifEnabled =
    { parent, cfg, ... }:
    {
      services.k3s = {
        inherit (cfg) clusterInit;
        serverAddr = if !cfg.clusterInit then "https://${cfg.kubeVip}:6443" else "";
        extraFlags = [
          "--disable traefik"
          "--disable servicelb"
          "--flannel-backend=vxlan"
          "--tls-san ${staticHosts.kube-vip}"
          "--tls-san kube-vip.${domain}"
        ];
      };

      systemd.services.k3s = {
        # default service from nixpkgs module includes firewall.service which we're not using
        after = lib.mkForce [ "network-online.target" ];
        wants = lib.mkForce [ "network-online.target" ];
      };
    };
}
