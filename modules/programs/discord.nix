{
    delib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "programs.discord";

    options = delib.singleEnableOption host.guiFeatured;

    home.ifEnabled.home.packages = [
        pkgs.discord
    ];
}
