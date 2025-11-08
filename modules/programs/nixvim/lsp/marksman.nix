{ delib, ... }:
delib.module {
  name = "programs.nixvim.lsp.marksman";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled = {
    programs.nixvim.lsp.servers.marksman = {
      enable = true;
    };
  };
}
