{
  delib,
  host,
  pkgs,
  lib,
  config,
  ...
}:
delib.module {
  name = "services.forgejo-runner";

  options =
    with delib;
    moduleOptions {
      enable = boolOption host.forgejoRunnerFeatured;
      instanceName = strOption host.name;
    };

  nixos.ifEnabled =
    { cfg, ... }:
    {
      users = {
        groups.gitea-runner = { };
        users.gitea-runner = {
          isSystemUser = true;
          group = "gitea-runner";
          description = "forgejo runner user";
        };
      };
      sops.secrets = {
        forgejo_runner_registration_token.restartUnits = [
          "gitea-runner-${cfg.instanceName}"
        ];
        forgejo_runner_kubeconfig = {
          restartUnits = [ "gitea-runner-${cfg.instanceName}" ];
          owner = "gitea-runner";
          mode = "0400";
        };
      };
      services.gitea-actions-runner = {
        package = pkgs.forgejo-runner;

        instances."${cfg.instanceName}" = {
          enable = true;
          name = cfg.instanceName;
          url = "https://forgejo.apps.chesurah.net";
          tokenFile = config.sops.secrets.forgejo_runner_registration_token.path;
          labels = [ "native:host" ];
          hostPackages = with pkgs; [
            bash
            coreutils
            curl
            gitMinimal
            gnused
            kubectl
            nodejs # needed for builtin actions
          ];
        };
      };
      systemd.services."gitea-runner-${cfg.instanceName}" = {
        serviceConfig = {
          DynamicUser = lib.mkForce false;
          User = "gitea-runner";
        };
        environment = {
          KUBECONFIG = config.sops.secrets.forgejo_runner_kubeconfig.path;
        };
      };
    };
}
