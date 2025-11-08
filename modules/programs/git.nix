{ delib, pkgs, ... }:
delib.module {
  name = "programs.git";

  options = delib.singleEnableOption true;

  home.ifEnabled =
    { myconfig, ... }:
    {
      programs.delta = {
        enable = true;
        enableGitIntegration = true;
        options = {
          line-numbers = true;
          # styles from https://github.com/folke/tokyonight.nvim/blob/main/extras/delta/tokyonight_storm.gitconfig
          minus-style = "syntax #52313f";
          minus-non-emph-style = "syntax #52313f";
          minus-emph-style = "syntax #763842";
          minus-empty-line-marker-style = "syntax #52313f";
          line-numbers-minus-style = "#914c54";
          plus-style = "syntax #2b485a";
          plus-non-emph-style = "syntax #2b485a";
          plus-emph-style = "syntax #316172";
          plus-empty-line-marker-style = "syntax #2b485a";
          line-numbers-plus-style = "#449dab";
          line-numbers-zero-style = "#3b4261";
        };
      };
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
          push = {
            autoSetupRemote = true;
            followTags = true;
          };
          diff = {
            colorMoved = "zebra";
            algorithm = "patience";
          };
          color = {
            ui = "auto";
            status = "auto";
            branch = "auto";
          };
          rerere.enabled = true; # remember conflict resolutions for future merges
          fetch.prune = true;
        };
      };
    };

  nixos.ifEnabled.environment.systemPackages = [ pkgs.git ];
}
