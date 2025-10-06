{ delib, ... }:
delib.module {
  name = "programs.nixvim.plugins";
  home.ifEnabled.programs.nixvim.plugins.lint = {
    enable = true;
    lintersByFt = {
      nix = [ "statix" ];
    };
  };
}
