{ delib, ... }:
delib.module {
  name = "programs.terminal.ghostty";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled = {
    programs.ghostty = {
      enable = true;
      settings = {
        theme = "TokyoNight Storm";
        font-family = "SauceCodePro Nerd Font Mono";
        font-size = 14;
      };
    };
  };
}
