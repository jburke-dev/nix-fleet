{ delib, ... }:
delib.module {
  name = "programs.nixvim.plugins";

  home.ifEnabled.programs.nixvim.plugins.noice = {
    enable = true;
  };
}
