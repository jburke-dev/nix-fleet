{ delib, ... }:
delib.module {
  name = "programs.nixvim.opts";

  home.ifEnabled.programs.nixvim = {
    keymaps = [
      {
        action = "<ESC>";
        key = "jj";
        mode = [ "i" ];
      }
      {
        action = "<NOP>";
        key = "Q";
        mode = [ "n" ];
        options.desc = "Disable Q (Ex Mode)";
      }
      {
        action = "\"+y";
        key = "<leader>y";
        mode = [
          "n"
          "v"
        ];
        options.desc = "Yank to system clipboard";
      }
      {
        action = "<C-d>zz";
        key = "<C-d>";
        mode = [ "n" ];
        options.desc = "Center after scroll down";
      }
      {
        action = "<C-u>zz";
        key = "<C-u>";
        mode = [ "n" ];
        options.desc = "Center after scroll down";
      }
    ];
  };
}
