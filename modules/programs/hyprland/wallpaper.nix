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
          (builtins.listToAttrs (
            map (display: {
              inherit (display) name;
              value = {
                path = display.wallpaperPath;
              };
            }) parent.displays
          ))
        ];
      };
    };
}
