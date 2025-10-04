{
  delib,
  lib,
  ...
}:
delib.module {
  name = "programs.hyprland.wallpaper";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled =
    { parent, ... }:
    {
      services.wpaperd = {
        enable = true;
        settings = lib.mkMerge [
          {
            default = {
              duration = "1m";
            };
          }
          (builtins.mapAttrs (_: display: {
            path = display.wallpaperPath;
          }) parent.displays)
        ];
      };
    };
}
