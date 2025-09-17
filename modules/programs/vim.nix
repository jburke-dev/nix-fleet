{
    delib,
    pkgs,
    ...
}:
delib.module {
    name = "programs.vim";

    options = delib.singleEnableOption true;

    nixos.ifEnabled.environment.systemPackages = [pkgs.vim];
}
