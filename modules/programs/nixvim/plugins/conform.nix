{ delib, ... }:
delib.module {
    name = "programs.nixvim.plugins";

    home.ifEnabled.programs.nixvim.plugins.conform-nvim = {
        enable = true;
        settings = {
            notify_on_errort = true;
            formatters_by_ft = {
                nix = [ "nixfmt" ];
            };
            format_on_save = {
                lsp_format = "fallback";
                timeout_ms = 500;
            };
        };
    }; 
}
