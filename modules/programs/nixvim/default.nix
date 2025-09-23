{
  delib,
  inputs,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.nixvim";

  options.programs.nixvim = with delib; {
    enable = boolOption host.devFeatured;
    defaultEditor = boolOption true;
  };

  myconfig.always.args.shared.nixvimLib = inputs.nixvim.lib;

  home.always.imports = [ inputs.nixvim.homeManagerModules.nixvim ];

  home.ifEnabled =
    { cfg, ... }:
    {
      home.packages = with pkgs; [
        xclip
        just
        nixfmt-rfc-style
      ];
      programs.nixvim = {
        enable = true;
        inherit (cfg) defaultEditor;
      };
    };
}
