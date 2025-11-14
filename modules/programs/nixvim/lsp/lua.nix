{ delib, ... }:
delib.module {
  name = "programs.nixvim.lsp.lua";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled = {
    programs.nixvim.lsp.servers = {
      lua_ls.enable = true;
    };
  };
}
