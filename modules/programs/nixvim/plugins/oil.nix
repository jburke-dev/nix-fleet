{ delib, ... }:
delib.module {
    name = "programs.nixvim.plugins.oil";

    options = delib.singleEnableOption true;

    home.ifEnabled.programs.nixvim = { 
        plugins.oil = {
            enable = true;
        };

        keymaps = [
            {
                action = "<cmd>Oil<cr>";
                key = "-";
                mode = [ "n" ];
            }
        ];
    };
}
