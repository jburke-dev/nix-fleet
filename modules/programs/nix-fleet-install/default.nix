{
  delib,
  pkgs,
  host,
  ...
}:
delib.module {
  name = "programs.nix-fleet-install";

  options =
    with delib;
    moduleOptions {
      enable = boolOption host.installerFeatured;
    };

  nixos.ifEnabled =
    { cfg, ... }:
    let
      output-config = pkgs.writeShellApplication {
        name = "nix-fleet-output-config";
        text = builtins.readFile ./output-config.sh;
      };
    in
    {
      environment.systemPackages = [
        output-config
        (pkgs.writeShellApplication {
          name = "nix-fleet-install";
          runtimeInputs = with pkgs; [
            nixos-install-tools
            git
            parted
            gptfdisk
            e2fsprogs
            dosfstools
            util-linux
            coreutils
            output-config
          ];
          text = builtins.readFile ./nix-fleet-install.sh;
        })
      ];
    };
}
