{ delib, ... }:
delib.module {
  name = "programs.nixvim.lsp.yamlls";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled = {
    programs.nixvim.lsp.servers = {
      yamlls.enable = true;
    };
  };
}
