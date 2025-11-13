{ delib, ... }:
delib.module {
  name = "programs.nixvim.plugins";

  home.ifEnabled.programs.nixvim = {
    plugins.telescope = {
      enable = true;
    };

    keymaps = [
      {
        action = "<cmd>Telescope find_files<CR>";
        key = "<leader>ff";
        mode = [ "n" ];
        options.desc = "Find files";
      }
      {
        action = "<cmd>Telescope live_grep<CR>";
        key = "<leader>fg";
        mode = [ "n" ];
        options.desc = "Live grep";
      }
      {
        action = "<cmd>Telescope man_pages<CR>";
        key = "<leader>fm";
        mode = [ "n" ];
        options.desc = "Man pages";
      }
      {
        action = "<cmd>Telescope help_tags<CR>";
        key = "<leader>fh";
        mode = [ "n" ];
        options.desc = "Help tags";
      }
      {
        action = "<cmd>Telescope grep_string<CR>";
        key = "<leader>f*";
        mode = [ "n" ];
        options.desc = "Search word under cursor";
      }
      {
        action = "<cmd>Telescope diagnostics<CR>";
        key = "<leader>fd";
        mode = [ "n" ];
        options.desc = "Diagnostics";
      }
      {
        action = "<cmd>Telescope lsp_document_symbols<CR>";
        key = "<leader>fs";
        mode = [ "n" ];
        options.desc = "Current document symbols";
      }
      {
        action = "<cmd>Telescope lsp_references<CR>";
        key = "<leader>fr";
        mode = [ "n" ];
        options.desc = "References to symbol under cursor";
      }
    ];
  };
}
