{ delib, ... }:
delib.module {
  name = "programs.nixvim.lsp.k8s";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled = {
    programs.nixvim.lsp.servers = {
      helm_ls.enable = true;
      yamlls = {
        enable = true;
        config = {
          settings.yaml = {
            schemas = {
              "kubernetes" = "**/manifests/**/*.yaml";
            };
          };
        };
      };
    };
  };
}
