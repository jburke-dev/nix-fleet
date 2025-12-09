{ delib, ... }:
delib.module {
  name = "programs.nixvim.plugins";

  home.ifEnabled.programs.nixvim = {
    plugins.blink-cmp = {
      enable = true;
      setupLspCapabilities = true;

      settings = {
        signature.enabled = true;

        appearance = {
          nerd_font_variant = "mono";
        };

        completion = {
          trigger.prefetch_on_insert = false;
          accept.auto_brackets.enabled = false;
          menu = {
            border = "none";
            draw = {
              columns = [
                {
                  __unkeyed-1 = "label";
                  __unkeyed-2 = "label_description";
                  gap = 2;
                }
                {
                  __unkeyed-1 = "kind_icon";
                  __unkeyed-2 = "kind";
                }
              ];
            };
          };
          documentation = {
            auto_show = true;
            auto_show_delay_ms = 500;
            window.border = "single";
          };
        };
        sources = {
          default = [
            "lsp"
            "path"
            "buffer"
          ];
        };
      };

    };
  };
}
