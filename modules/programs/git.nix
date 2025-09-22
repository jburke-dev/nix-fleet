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

        userName = myconfig.constants.userfullname;
        userEmail = myconfig.constants.useremail;

        extraConfig = {
          init.defaultBranch = "main";
        };
      };
    };

  nixos.ifEnabled.environment.systemPackages = [ pkgs.git ];
}
