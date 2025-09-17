{ delib, host, ... }:
delib.module {
    name = "programs.firefox";

    options = delib.singleEnableOption host.guiFeatured;

    home.ifEnabled.programs.firefox.enable = true;
}
