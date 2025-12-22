{ delib, ... }:
delib.module {
  name = "programs.nixvim.lsp.tofu";
  options = delib.singleCascadeEnableOption;

  home.ifEnabled = {
    programs.nixvim.lsp.servers = {
      tofu_ls = {
        enable = true;
        packageFallback = true;
      };
    };
  };
}
