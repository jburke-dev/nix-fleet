{
  delib,
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
    };
}
