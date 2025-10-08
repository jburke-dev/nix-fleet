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

        inherit (myconfig.constants) userEmail;

        userName = myconfig.constants.userFullName;

        extraConfig = {
          credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
          init.defaultBranch = "main";
          push.autoSetupRemote = true;
        };
      };
    };

  nixos.ifEnabled.environment.systemPackages = [ pkgs.git ];
}
