{
  delib,
  host,
  nixpkgs-unstable,
  pkgs,
  ...
}:
let
  pkgs-unstable = import nixpkgs-unstable {
    system = pkgs.system;
    config = pkgs.config;
  };
in
delib.module {
  name = "programs.ghostty";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled = {
    programs.ghostty = {
      enable = true;
      package = pkgs-unstable.ghostty;
      settings = {
        theme = "TokyoNight Storm";
        font-family = "SauceCodePro Nerd Font";
        font-size = 14;
        keybind = [
          "ctrl+a>t=new_tab"
          "ctrl+a>n=next_tab"
          "ctrl+a>p=previous_tab"
          "ctrl+a>s=new_split:right"
          "ctrl+a>v=new_split:down"
          "ctrl+a>j=goto_split:top"
          "ctrl+a>h=goto_split:previous"
          "ctrl+a>k=goto_split:bottom"
          "ctrl+a>l=goto_split:next"
        ];
        shell-integration-features = true;
      };
    };
  };
}
