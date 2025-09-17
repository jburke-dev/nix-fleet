{
    delib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "programs.teams";

    options = delib.singleEnableOption host.guiFeatured;

    home.ifEnabled.home.packages = [pkgs.teams-for-linux];
}
