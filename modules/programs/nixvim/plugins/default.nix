{ delib, ... }:
delib.module {
  name = "programs.nixvim.plugins";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled.programs.nixvim = {
    plugins = {
      oil.enable = true;
      lualine.enable = true;
      web-devicons.enable = true;
      vim-css-color.enable = true;
      noice.enable = true;
    };

    keymaps = [
      {
        action = "<cmd>Oil<cr>";
        key = "-";
        mode = [ "n" ];
      }
    ];
  };
}
