{ delib, ... }:
delib.module {
  name = "programs.nixvim.lsp.web";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled.programs.nixvim.lsp.servers = {
    cssls.enable = true;
  };
}
