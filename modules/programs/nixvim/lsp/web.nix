{ delib, ... }:
delib.module {
  name = "programs.nixvim.lsp.web";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled = {
    programs.nixvim.lsp.servers = {
      ts_ls.enable = true;
      cssls.enable = true;
      jsonls.enable = true;
    };
  };
}
