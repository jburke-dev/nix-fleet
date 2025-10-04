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
    };

  home.ifEnabled =
    { cfg, ... }:
    {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks = {
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
          "github.com" = {
            hostname = "github.com";
            identityFile = "${cfg.sshRootDir}/id_github";
          };
        };
      };
    };
}
