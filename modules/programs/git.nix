{ delib, pkgs, ... }:
delib.module {
  name = "programs.git";

  options = delib.singleEnableOption true;

  home.ifEnabled =
    { myconfig, ... }:
    {
      programs.git = {
        enable = true;
        lfs.enable = true;

        settings = {
          user = {
            email = myconfig.constants.userEmail;
            name = myconfig.constants.userFullName;
          };
          credential.helper = "store";
          init.defaultBranch = "main";
          push.autoSetupRemote = true;
        };
      };
    };

  nixos.ifEnabled.environment.systemPackages = [ pkgs.git ];
}
