{ delib, ... }:
delib.module {
    name = "programs.nixvim";
    home.ifEnabled.programs.nixvim = {
        colorschemes.tokyonight = {
            enable = true;
            settings.style = "storm";
        };
    };
}
