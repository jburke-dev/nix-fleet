{
  delib,
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
      }
    );

  nixos.ifEnabled =
    { parent, cfg, ... }:
    {
      services.k3s = {
        inherit (cfg) clusterInit;
        serverAddr = if !cfg.clusterInit then "https://${parent.kubeVip}:6443" else "";
        extraFlags = [
          "--disable traefik"
          "--disable servicelb"
          "--flannel-backend=vxlan"
          "--tls-san ${staticHosts.kube-vip}"
          "--tls-san kube-vip.${domain}"
        ];
      };
    };
}
