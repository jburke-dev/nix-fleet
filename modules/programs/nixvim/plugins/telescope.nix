{ delib, ... }:
delib.module {
    name = "programs.nixvim.plugins.telescope";

    options = delib.singleEnableOption true;

    home.ifEnabled.programs.nixvim = {
        plugins.telescope = {
            enable = true;
        };

        keymaps = [
            {
                action = "<cmd>Telescope find_files<CR>";
                key = "<leader>ff";
                mode = [ "n" ];
            }
            {
                action = "<cmd>Telescope live_grep<CR>";
                key = "<leader>fg";
                mode = [ "n" ];
            }
            {
                action = "<cmd>Telescope man_pages<CR>";
                key = "<leader>fm";
                mode = [ "n" ];
            }
            {
                action = "<cmd>Telescope help_tags<CR>";
                key = "<leader>fh";
                mode = [ "n" ];
            }
        ];
    };
}
