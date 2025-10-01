{
  delib,
  config,
  host,
  lib,
  pkgs,
  ...
}:
delib.module {
  name = "services.forgejo-runner";

  options =
    with delib;
    moduleOptions {
      enable = boolOption false;
      instanceName = strOption host.name;
    };

  nixos.ifEnabled =
    { cfg, ... }:
    {
      sops.secrets.forgejo_runner_registration_token.restartUnits = [
        "gitea-runner-${cfg.instanceName}"
      ];
      services.gitea-actions-runner = {
        package = pkgs.forgejo-actions-runner;
        instances."${cfg.instanceName}" = {
          enable = true;
          name = "colossus";
          url = "https://forgejo.apps.chesurah.net";
          tokenFile = config.sops.secrets.forgejo_runner_registration_token.path;
          labels = [ "native:host" ];
        };
      };
    };
}
