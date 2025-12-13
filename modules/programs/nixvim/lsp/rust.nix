{ delib, pkgs, ... }:
delib.module {
  name = "programs.nixvim.lsp.rust";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled = {
    #home.packages = with pkgs; [ crates-lsp ];
    programs.nixvim = {
      plugins.lsp.servers = {
        rust_analyzer = {
          enable = true;
          packageFallback = true;
          # rely on devshells for these
          installCargo = false;
          installRustc = false;
          installRustfmt = false;
        };
      };
    };
  };
}
