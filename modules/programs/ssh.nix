{
    delib,
    ...
}:
delib.module {
    name = "programs.ssh";

    options = delib.singleEnableOption true;

    home.ifEnabled.programs.ssh = {
        enable = true;
        # TODO: setup persist?
        includes = [ "~/Code/nix-dotfiles/config/ssh/*" ];
    };
}
