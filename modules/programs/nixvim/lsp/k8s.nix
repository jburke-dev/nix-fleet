{ delib, ... }:
delib.module {
  name = "programs.nixvim.lsp.k8s";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled = {
    programs.nixvim.lsp.servers = {
      yamlls.enable = true;
      helm_ls.enable = true;
    };
  };
}
