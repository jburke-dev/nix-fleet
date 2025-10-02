{
  delib,
  host,
  lib,
  ...
}:
delib.module {
  name = "programs.ssh";

  options = delib.singleEnableOption true;

  home.ifEnabled.programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        identityFile = "/mnt/apps/ssh/id_github";
      };
    };
    userKnownHostsFile = "/mnt/apps/ssh/known_hosts";
  };
}
