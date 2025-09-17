{
    delib,
    host,
    pkgs,
    ...
}:
delib.module {
    name = "programs.ghostty";

    options = delib.singleEnableOption host.guiFeatured;

    home.ifEnabled = {
        home.packages = with pkgs; [ ghostty ];
        xdg.configFile."ghostty/config" = {
            source = ../../.config/ghostty/config;
        };
    };
}
