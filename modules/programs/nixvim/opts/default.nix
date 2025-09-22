{ delib, ... }:
delib.module {
  name = "programs.nixvim.opts";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled.programs.nixvim = {
    globals.mapleader = " ";

    opts = {
      number = true;

      expandtab = true;
      tabstop = 4;
      shiftwidth = 4;
      softtabstop = 4;

      title = true;
      cursorline = true;
      termguicolors = true;
      signcolumn = "yes";

      hlsearch = false;
      incsearch = true;

      scrolloff = 8;
      updatetime = 50;

      clipboard = "unnamedplus";
    };
  };
}
