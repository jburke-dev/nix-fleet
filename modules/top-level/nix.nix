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
        substituters = [
          "https://cache.apps.chesurah.net/homelab"
        ];
        trusted-public-keys = [
          "homelab:6jwrO+U2g8IMJ56713iWkjo+xT7+vPn8GL0si2jZv0M="
        ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
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
