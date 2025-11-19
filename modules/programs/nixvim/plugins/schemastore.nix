{ delib, pkgs, ... }:
delib.module {
  name = "programs.nixvim.plugins.schemastore";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled.programs.nixvim.plugins.schemastore = {
    enable = true;
    json.settings = {
      extra = [
        {
          description = "opencode config JSON schema";
          fileMatch = "opencode.json";
          name = "opencode.json";
          url = "https://opencode.ai/config.json";
        }
      ];
    };
  };
}
