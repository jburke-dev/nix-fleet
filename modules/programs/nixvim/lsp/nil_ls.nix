{ delib, ... }:
delib.module {
  name = "programs.nixvim.lsp.nil_ls";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled.programs.nixvim.lsp.servers.nil_ls = {
    enable = true;
    config.nil.nix.flake.autoEvalInputs = true;
  };
}
