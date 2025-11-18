{
  delib,
  lib,
  host,
  config,
  staticHosts,
  ...
}:
delib.module {
  name = "services.k3s";

  options =
    with delib;
    moduleOptions {
      enable = boolOption host.k3sFeatured;
      role = enumOption [ "server" "agent" ] "server";
      bootstrapHost = readOnly (strOption "kraken");
      kubeVip = strOption "10.12.1.100";
    };

  nixos.ifEnabled =
    { cfg, ... }:
    {
      sops.secrets.k3s_token.restartUnits = [ "k3s.service" ];
      services.k3s = {
        enable = true;
        inherit (cfg) role;
        gracefulNodeShutdown.enable = true;
        tokenFile = config.sops.secrets.k3s_token.path;
        extraFlags = [ "--node-ip ${staticHosts.${host.name}}" ];
      };

      systemd.services.k3s = {
        # default service from nixpkgs module includes firewall.serVice which we're not using
        after = lib.mkForce [ "network-online.target" ];
        wants = lib.mkForce [ "network-online.target" ];
      };
    };
}
