{
  delib,
  pkgs,
  lib,
  ...
}:
let
  shared = {
    nix = {
      package = lib.mkForce pkgs.nixVersions.latest;
      settings = {
        auto-optimise-store = true;
        require-sigs = false;
        warn-dirty = false;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        trusted-users = [
          "root"
          "@wheel"
        ];
      };
    };
    nixpkgs.config.allowUnfree = true;
  };
in
delib.module {
  name = "nix";

  nixos.always = shared;
  home.always = shared;
}
