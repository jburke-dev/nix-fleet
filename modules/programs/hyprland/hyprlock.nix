{
  delib,
  host,
  ...
}:
delib.module {
  name = "programs.hyprland.hyprlock";
  options = delib.singleCascadeEnableOption;

  home.ifEnabled.programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };
      animation = "fadeIn,0,0,default";
      input-field = {
        monitor = "";
        size = "200, 50";

        fade_on_empty = false;
        placeholder_text = "<span>Password:</span>";
      };
    };
  };
}
