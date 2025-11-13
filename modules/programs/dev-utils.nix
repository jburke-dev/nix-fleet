{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.dev-utils";

  options = delib.singleEnableOption host.devFeatured;

  home.ifEnabled = {
    home.packages = with pkgs; [
      just
      nixfmt-rfc-style
      sops
      age
      xz
      file
    ];
  };
}
