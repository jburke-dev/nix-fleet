{ delib, ... }:
delib.module {
  name = "programs.nixvim.plugins";

  home.ifEnabled.programs.nixvim.plugins.claude-code = {
    enable = true;
  };
}
