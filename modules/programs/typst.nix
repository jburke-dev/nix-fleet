{ delib, host, pkgs, ... }:
delib.module {
    name = "programs.typst";

    options = delib.singleEnableOption host.devFeatured;

    # TODO: figure out dev-shell stuff for this
    home.ifEnabled.home.packages = with pkgs; [ typst tinymist typstPackages.fontawesome ];
}
