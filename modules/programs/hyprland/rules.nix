{
  delib,
  lib,
  ...
}:
delib.module {
  name = "programs.hyprland.rules";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled =
    { parent, ... }:
    {
      wayland.windowManager.hyprland = {
        settings = {
          windowrule = [
            # TODO: adapt this for single-monitor hosts?
            "workspace ${toString (parent.workspacesPerDisplay + 1)}, class:vivaldi-stable"
            "workspace ${toString (parent.workspacesPerDisplay + 1)}, class:zen-twilight"
            "workspace 2, class:discord"
            "bordersize 0, floating:0, onworkspace:w[tv1]s[false]"
            "rounding 0, floating:0, onworkspace:w[tv1]s[false]"
            "bordersize 0, floating:0, onworkspace:f[1]s[false]"
            "rounding 0, floating:0, onworkspace:f[1]s[false]"
            "opacity 0.9 0.5, class:com.mitchellh.ghostty"
          ];
          windowrulev2 = [
            # Steam games - force to HDMI display
            #"monitor HDMI-A-1, class:^steam_app_"
            #"workspace 1, class:^steam_app_"
            # Obsidian - left 1/3 of ultrawide for sol workspace
            "size 33% 100%, initialTitle:^.*sol - Obsidian.*$" # TODO: size only works on floating windows
            "move 0 0, initialTitle:^.*sol - Obsidian.*$"
          ];
          layerrule = [
            "blur, gtk4-layer-shell"
            "ignorealpha 0, gtk4-layer-shell"
            "noanim, gtk4-layer-shell"
          ];
          monitor =
            (builtins.map (
              display:
              "${display.name}, ${display.resolution}, ${if display.leftMost then "0x0" else "auto-right"}, 1"
            ) parent.displays)
            ++ [
              ", preferred, auto, 1" # place newly plugged in monitors to the right of existing ones with preferred resolution
            ];
          workspace = [
            "w[tv1]s[false], gapsout:0, gapsin:0" # set gaps for non-special workspaces with only 1 visible tiled window
            "f[1]s[false], gapsout:0, gapsin:0" # same as above but maximized
          ]
          ++ (lib.lists.imap0 (
            i: display:
            "${toString (i * parent.workspacesPerDisplay + 1)}, monitor:${display.name}, default:true"
          ) parent.displays);
        };
      };
    };
}
