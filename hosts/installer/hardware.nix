{ delib, modulesPath, ... }:
delib.host {
    name = "installer";

    system = "x86_64-linux";

    homeManagerSystem = "x86_64-linux";
    home.home.stateVersion = "25.05";

    nixos = {
        system.stateVersion = "25.05";

        imports = [(modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")];
    };
}
