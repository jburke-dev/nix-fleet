{ delib, host, ... }:
delib.module {
  name = "programs.kitty";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled = {
    programs.kitty = {
      enable = true;
      keybindings = {
        "ctrl+shift+n" = "launch --cwd=current --type=os-window";
      };
      font = {
        name = "SauceCodePro Nerd Font Mono";
        size = 14;
      };
      themeFile = "tokyo_night_storm";
    };
  };
}
