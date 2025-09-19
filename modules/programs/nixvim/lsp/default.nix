{ delib, ... }:
delib.module {
    name = "programs.nixvim.lsp";

    options = delib.singleCascadeEnableOption;

    home.ifEnabled.programs.nixvim.plugins = {
        lsp = {
            enable = true;
        };
        lsp-format = {
            enable = true;
        };
    };
}
