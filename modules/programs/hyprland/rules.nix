{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.hyprland.rules";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled = {
    wayland.windowManager.hyprland = {
      settings = {
        windowrule = [
          # TODO: adapt this for single-monitor hosts?
          "workspace 5, class:zen-twilight"
          "workspace 5, class:vivaldi-stable"
          "workspace 2, class:discord"
          "bordersize 0, floating:0, onworkspace:w[tv1]s[false]"
          "rounding 0, floating:0, onworkspace:w[tv1]s[false]"
          "bordersize 0, floating:0, onworkspace:f[1]s[false]"
          "rounding 0, floating:0, onworkspace:f[1]s[false]"
          "opacity 0.9 0.5, class:com.mitchellh.ghostty"
        ];
        workspace = [
          "1, monitor:HDMI-A-1, default:true"
          "r[2-4], monitor:HDMI-A-1"
          "w[tv1]s[false], gapsout:0, gapsin:0" # set gaps for non-special workspaces with only 1 visible tiled window
          "f[1]s[false], gapsout:0, gapsin:0" # same as above but maximized
          "5, monitor:DP-2, default:true"
        ];
      };
    };
  };
}
