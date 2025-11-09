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
    enableExtras = boolOption host.devFeatured;
  };

  nixos.ifEnabled = {
    programs.zsh.enable = true;

    environment.shells = with pkgs; [ zsh ];
    users.defaultUserShell = pkgs.zsh;
  };

  home.ifEnabled =
    { cfg, ... }:
    {
      home.packages =
        with pkgs;
        lib.mkIf cfg.enableExtras [
          fzf
          ripgrep
          zoxide
        ];

      programs = {
        direnv.enable = true;
        zsh = {
          enable = true;
          enableCompletion = cfg.enableExtras;
          autosuggestion.enable = cfg.enableExtras;
          syntaxHighlighting.enable = cfg.enableExtras;

          shellAliases = lib.mkIf cfg.enableExtras {
            claude-full = "claude --mcp-config ~/.config/claude/mcp-servers.json";
          };

          zplug = lib.mkIf cfg.enableExtras {
            enable = true;
            plugins = [
              { name = "zsh-users/zsh-autosuggestions"; }
              { name = "Aloxaf/fzf-tab"; }
              {
                name = "plugins/git";
                tags = [ "from:oh-my-zsh" ];
              }
              {
                name = "jackharrisonsherlock/common";
                tags = [ "as:theme" ];
              }
              { name = "unixorn/fzf-zsh-plugin"; }
            ];
          };

          history = {
            size = 10000;
            ignoreAllDups = true;
            path = "${homeconfig.home.homeDirectory}/.zsh_history";
          };
        };

        fzf = lib.mkIf cfg.enableExtras {
          enable = true;
          enableZshIntegration = true;
        };

        zoxide = lib.mkIf cfg.enableExtras {
          enable = true;
          enableZshIntegration = true;
        };
      };
    };
}
