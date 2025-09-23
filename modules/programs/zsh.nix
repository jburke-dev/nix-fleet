{
  delib,
  homeconfig,
  lib,
  pkgs,
  host,
  ...
}:
delib.module {
  name = "programs.zsh";

  options.programs.zsh = with delib; {
    enable = boolOption true;
    enableExtras = boolOption host.cliFeatured;
  };

  nixos.ifEnabled = {
    programs.zsh.enable = true;

    environment.shells = with pkgs; [ zsh ];
    users.defaultUserShell = pkgs.zsh;
    system.userActivationScripts.zshrc = "touch .zshrc";
  };

  home.ifEnabled =
    { cfg, ... }:
    {
      home.packages =
        with pkgs;
        lib.mkIf (cfg.enableExtras) [
          fzf
          ripgrep
          zoxide
        ];

      programs.direnv.enable = true;
      programs.zsh = {
        enable = true;
        enableCompletion = cfg.enableExtras;
        autosuggestion.enable = cfg.enableExtras;
        syntaxHighlighting.enable = cfg.enableExtras;

        zplug = lib.mkIf (cfg.enableExtras) {
          enable = true;
          plugins = [
            { name = "zsh-users/zsh-autosuggestions"; }
            { name = "jeffreytse/zsh-vi-mode"; }
            { name = "Aloxaf/fzf-tab"; }
            {
              name = "plugins/git";
              tags = [ "from:oh-my-zsh" ];
            }
            {
              name = "jackharrisonsherlock/common";
              tags = [ "as:theme" ];
            }
          ];
        };

        history.size = 10000;
        history.ignoreAllDups = true;
        history.path = "${homeconfig.home.homeDirectory}/.zsh_history";
      };

      programs.fzf = lib.mkIf (cfg.enableExtras) {
        enable = true;
        enableZshIntegration = true;
      };

      programs.zoxide = lib.mkIf (cfg.enableExtras) {
        enable = true;
        enableZshIntegration = true;
      };
    };
}
