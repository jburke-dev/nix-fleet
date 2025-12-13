{ delib, ... }:
delib.module {
  name = "programs.nixvim.plugins";

  home.ifEnabled = {
    programs.nixvim = {
      plugins.crates = {
        enable = true;
        settings = {
          autoload = true;
          autoupdate = true;
          smart_insert = true;
          thousands_separator = ",";

          lsp = {
            enabled = true;
            actions = true;
            completion = true;
            hover = true;
          };
        };
      };
    };
  };
}
