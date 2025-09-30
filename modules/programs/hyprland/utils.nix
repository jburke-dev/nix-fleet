{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.hyprland.utils";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled = {
    home.packages = with pkgs; [
      wl-clipboard
      dunst
      hyprcursor
      hyprshot
    ];
  };
}
