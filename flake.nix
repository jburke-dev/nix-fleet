{
  description = "Modular configuration of NixOS with Denix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    denix = {
      url = "github:yunfachi/denix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-code.url = "github:sadjow/claude-code-nix";
  };

  outputs =
    {
      denix,
      flake-parts,
      nixpkgs-unstable,
      sops-nix,
      stylix,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ]; # this will eventually include at least darwin
      flake =
        let
          mkConfigurations =
            moduleSystem:
            denix.lib.configurations {
              inherit moduleSystem;
              homeManagerUser = "jburke";

              paths = [
                ./hosts
                ./modules
                ./rices
              ];

              extensions = with denix.lib.extensions; [
                args
                overlays
                (base.withConfig {
                  args.enable = true;
                  rices.enable = true;
                  hosts.features = {
                    features = [
                      "gui"
                      "gnome"
                      "hyprland"
                      "gaming"
                      "dev"
                      "installer"
                      "reverseProxy"
                    ];
                    defaultByHostType = {
                      desktop = [
                        "gui"
                        "hyprland"
                        "gaming"
                        "dev"
                      ];
                      server = [ ];
                      laptop = [
                        "gui"
                        "gnome"
                        "dev"
                      ];
                    };
                  };
                })
              ];

              specialArgs = {
                inherit
                  inputs
                  moduleSystem
                  nixpkgs-unstable
                  ;
                sops-nix = inputs.sops-nix;
              };
            };
        in
        {
          nixosConfigurations = mkConfigurations "nixos";
          homeConfigurations = mkConfigurations "home";
        };

      perSystem =
        { pkgs, ... }:
        {
          formatter = pkgs.nixfmt-tree;
        };
    };
}
