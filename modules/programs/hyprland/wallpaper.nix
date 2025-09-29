{
  delib,
  lib,
  ...
}:
delib.module {
  name = "programs.hyprland.wallpaper";

  options =
    with delib;
    moduleOptions (
      { parent, ... }:
      {
        enable = boolOption parent.enable;
        displays = attrsOfOption (submodule (
          { config, ... }:
          {
            options = {
              path = noDefault (pathOption null);
            };
          }
        )) { };
      }
    );

  home.ifEnabled =
    { cfg, ... }:
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
            inherit (display) path;
          }) cfg.displays)
        ];
      };
    };
}
