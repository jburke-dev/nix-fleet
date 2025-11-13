{ delib, pkgs, ... }:
delib.module {
  name = "programs.nixvim.plugins";

  home.ifEnabled.programs.nixvim = {
    plugins.treesitter = {
      enable = true;

      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        json
        lua
        markdown
        nix
        regex
        toml
        vim
        vimdoc
        xml
        yaml
        helm
        typescript
        css
        just
      ];

      settings = {
        highlight = {
          enable = true;
          additional_vim_regex_highlighting = false;
        };
      };
    };
  };
}
