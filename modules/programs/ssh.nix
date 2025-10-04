{
  delib,
  host,
  lib,
  ...
}:
delib.module {
  name = "programs.ssh";

  options =
    with delib;
    moduleOptions {
      enable = boolOption true;
      sshRootDir = strOption "~/.ssh";
      keyConfigs = listOfOption (submodule (
        { config, ... }:
        {
          options = {
            host = strOption null;
            hostname = strOption "";
            identityFileSuffix = strOption null;
          };
        }
      )) [ ];
    };

  home.ifEnabled =
    { cfg, ... }:
    {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks = lib.mkMerge [
          {
            "*" = {
              userKnownHostsFile = "${cfg.sshRootDir}/known_hosts";
              forwardAgent = false;
              addKeysToAgent = "no";
              compression = false;
              serverAliveInterval = 0;
              serverAliveCountMax = 3;
              hashKnownHosts = false;

              controlMaster = "no";
              controlPath = "~/.ssh/master-%r@%n:%p";
              controlPersist = "no";
            };
          }
          (builtins.listToAttrs (
            map (keyConfig: {
              name = keyConfig.host;
              value = {
                hostname = if keyConfig.hostname != "" then keyConfig.hostname else keyConfig.host;
                identityFile = "${cfg.sshRootDir}/id_${keyConfig.identityFileSuffix}";
              };
            }) cfg.keyConfigs
          ))
        ];
      };
    };
}
