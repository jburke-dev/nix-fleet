{
  description = "Modular configuration of NixOS with Denix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    denix = {
      url = "github:yunfachi/denix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-code.url = "github:sadjow/claude-code-nix";
    ags-shell = {
      url = "github:jburke-dev/ags-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      denix,
      flake-parts,
      sops-nix,
      stylix,
      ags-shell,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.git-hooks-nix.flakeModule ];
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
                      "zfs"
                      "homeAssistant"
                      "nvidia"
                      "mediaServer"
                      "monitoring"
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
                        "hyprland"
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
                  ;
                inherit (inputs) sops-nix;
              };
            };
        in
        {
          nixosConfigurations = mkConfigurations "nixos";
          homeConfigurations = mkConfigurations "home";
        };

      perSystem =
        { pkgs, config, ... }:
        {
          formatter = pkgs.nixfmt-tree;
          pre-commit = {
            settings.hooks = {
              statix.enable = true;
              nixfmt-rfc-style.enable = true;
              commitizen.enable = true;
              shellcheck.enable = true;
            };
            check.enable = true;
          };
          devShells.default = pkgs.mkShell {
            shellHook = ''
              ${config.pre-commit.installationScript}
            '';
            packages = config.pre-commit.settings.enabledPackages;
          };
        };
    };
}
