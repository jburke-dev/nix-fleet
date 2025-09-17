{
    delib, host, ...
}:
delib.module {
    name = "localization";

    options.localization = with delib; {
        enable = boolOption host.isPC;

        timeZone = strOption "America/New_York";
        
        locale = strOption "en_US.UTF-8";
    };

    nixos.ifEnabled = { cfg, ... }: {
        time.timeZone = cfg.timeZone;
        environment.variables.TZ = cfg.timeZone;

        i18n = {
            defaultLocale = cfg.locale;
            extraLocaleSettings = {
                LC_ADDRESS = cfg.locale;
                LC_IDENTIFICATION = cfg.locale;
                LC_MEASUREMENT = cfg.locale;
                LC_MONETARY = cfg.locale;
                LC_NAME = cfg.locale;
                LC_NUMERIC = cfg.locale;
                LC_PAPER = cfg.locale;
                LC_TELEPHONE = cfg.locale;
                LC_TIME = cfg.locale;
            };
        };
    };
}
