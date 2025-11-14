{ delib, pkgs, ... }:
delib.module {
  name = "programs.nixvim.plugins.k8s-schema";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled.programs.nixvim = {
    #extraPlugins = [ pkgs.vimPlugins.plenary-nvim ];

    extraConfigLua = builtins.readFile ../lua/k8s-schema.lua;

    keymaps = [
      {
        action = "<cmd>K8sAddSchema<CR>";
        key = "<leader>ks";
        mode = [ "n" ];
        options.desc = "Add K8s CRD schema";
      }
    ];
  };
}
