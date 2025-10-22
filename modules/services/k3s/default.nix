{
  delib,
  host,
  lib,
  config,
  ...
}:
delib.module {
  name = "services.k3s";

  options =
    with delib;
    moduleOptions (
      { parent, ... }:
      {
        enable = boolOption host.k3sFeatured;
        clusterInit = boolOption false;
        role = enumOption [ "server" "agent" ] "server";
        interface = readOnly (strOption parent.hostVlans.k3s.netdevName);
        nodeIp = readOnly (strOption parent.hostVlans.k3s.address);
      }
    );

  nixos.ifEnabled =
    { cfg, myconfig, ... }:
    {
      sops.secrets.k3s_token.restartUnits = [ "k3s.service" ];
      services.k3s =
        let
          extraFlags =
            if cfg.role == "agent" then
              [ ]
            else
              [
                "--disable traefik"
                "--disable servicelb"
                "--node-ip=${cfg.nodeIp}"
                "--flannel-iface=${cfg.interface}"
              ]
              ++ lib.optionals cfg.clusterInit [
                "--tls-san ${myconfig.constants.k3sVip}"
                "--tls-san 192.168.21.6"
              ];
          serverAddr =
            if !cfg.clusterInit then "https://${myconfig.constants.k3sBootstrapServerIp}:6443" else "";
          tokenFile = if !cfg.clusterInit then config.sops.secrets.k3s_token.path else null;
        in
        {
          enable = true;
          inherit (cfg) clusterInit role;
          inherit extraFlags serverAddr tokenFile;
          gracefulNodeShutdown.enable = true;
          manifests = {
            kube-vip-rbac.source = ./manifests/kube-vip-rbac.yaml;
            kube-vip.source = ./manifests/kube-vip.yaml;
          };
        };

      networking.firewall.interfaces."${cfg.interface}" = {
        allowedTCPPorts = [
          # https://docs.k3s.io/installation/requirements#networking
          6443 # k3s supervisor and Kubernetes API server
          2379 # embedded etcd
          2380 # embedded etcd
          10250 # kubelet metrics
        ];
        allowedUDPPorts = [
          # Calico VXLAN encapsulation
          8472 # flannel vxlan
        ];
      };
    };
}
