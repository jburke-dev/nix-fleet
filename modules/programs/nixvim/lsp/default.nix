{ delib, ... }:
delib.module {
  name = "programs.nixvim.lsp";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled = {
    programs.nixvim = {
      lsp.keymaps = [
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
      plugins = {
        lsp = {
          enable = true;
        };
        lsp-format = {
          enable = true;
        };
      };
    };
  };
}
