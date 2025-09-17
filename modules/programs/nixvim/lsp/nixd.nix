{ delib, ... }:
delib.module {
    name = "programs.nixvim.lsp";

    home.ifEnabled.programs.nixvim.lsp = {
        servers.nixd.enable = true;

        keymaps = [
            {
                key = "gd";
                lspBufAction = "definition";
            }
            {
                key = "gD";
                lspBufAction = "declaration";
            }
            {
                key = "gt";
                lspBufAction = "type_definition";
            }
            {
                key = "gi";
                lspBufAction = "implementation";
            }
            {
                key = "<leader>ac";
                lspBufAction = "code_action";
            }
            {
                key = "<leader>ar";
                lspBufAction = "rename";
            }
        ];
    };
}
