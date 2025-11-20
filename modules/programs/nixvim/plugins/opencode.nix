{ delib, pkgs, ... }:
delib.module {
  name = "programs.nixvim.plugins";
  home.ifEnabled = {
    home.packages = with pkgs; [ lsof ];
    programs.nixvim = {
      plugins = {
        snacks = {
          enable = true;
          autoLoad = true;
          settings = {
            terminal.enabled = true;
            picker.enabled = true;
            input.enabled = true;
          };
        };
        opencode = {
          enable = true;
          settings = {
            auto_reload = true;
          };
        };
      };

      keymaps = [
        {
          mode = [
            "n"
            "x"
          ];
          key = "<leader>os";
          action.__raw = ''function() require("opencode").select() end'';
        }
        {
          mode = [
            "n"
            "x"
          ];
          key = "<leader>oa";
          action.__raw = ''function() require("opencode").ask({ submit = true }) end'';
        }
      ];
    };
  };
}
