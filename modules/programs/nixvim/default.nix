{
    delib,
    inputs,
    host,
    ...
}:
delib.module {
    name = "programs.nixvim";

    options.programs.nixvim = with delib; {
        enable = boolOption host.devFeatured;
        defaultEditor = boolOption true;
    };

    myconfig.always.args.shared.nixvimLib = inputs.nixvim.lib;

    home.always.imports = [inputs.nixvim.homeManagerModules.nixvim];

    home.ifEnabled = { cfg, ... }: {
        programs.nixvim = {
            enable = true;
            inherit (cfg) defaultEditor;

            globals.mapleader = " ";

            opts = {
                number = true;

                expandtab = true;
                tabstop = 4;
                shiftwidth = 4;
                softtabstop = 4;

                title = true;
                cursorline = true;
                termguicolors = true;
                signcolumn = "yes";

                hlsearch = false;
                incsearch = true;

                scrolloff = 8;
                updatetime = 50;

                clipboard = "unnamedplus";
            };
        };
    };
}
