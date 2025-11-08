{ delib, ... }:
delib.module {
  name = "programs.nixvim.lsp.just";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled = {
    programs.nixvim.lsp.servers = {
      just.enable = true;
    };
  };
}
