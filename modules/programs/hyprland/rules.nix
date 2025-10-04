{
  delib,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "programs.hyprland.rules";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled =
    { parent, ... }:
    {
      wayland.windowManager.hyprland =
        let
          multiDisplay = builtins.len (builtins.attrNames parent.displays) > 1;
        in
        {
          settings = {
            windowrule = [
              # TODO: adapt this for single-monitor hosts?
              "workspace ${toString (parent.workspacesPerDisplay + 1)}, class:vivaldi-stable"
              "workspace 2, class:discord"
              "bordersize 0, floating:0, onworkspace:w[tv1]s[false]"
              "rounding 0, floating:0, onworkspace:w[tv1]s[false]"
              "bordersize 0, floating:0, onworkspace:f[1]s[false]"
              "rounding 0, floating:0, onworkspace:f[1]s[false]"
              "opacity 0.9 0.5, class:com.mitchellh.ghostty"
            ];
            workspace = [
              "w[tv1]s[false], gapsout:0, gapsin:0" # set gaps for non-special workspaces with only 1 visible tiled window
              "f[1]s[false], gapsout:0, gapsin:0" # same as above but maximized
            ]
            ++ (lib.lists.imap0 (
              i: v: "${toString (i * parent.workspacesPerDisplay + 1)}, monitor:${v}, default:true"
            ) (builtins.attrNames parent.displays));
          };
        };
    };
}
