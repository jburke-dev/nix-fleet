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
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
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
    desktop-shell = {
      url = "git+https://forgejo.apps.chesurah.net/jburke-dev/desktop-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-anywhere = {
      url = "github:nix-community/nixos-anywhere";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    opencode = {
      url = "github:sst/opencode";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      denix,
      flake-parts,
      sops-nix,
      stylix,
      nixos-anywhere,
      disko,
      hyprland,
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
              exclude = [
                ./modules/lib
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
                      "hyprland"
                      "gaming"
                      "dev"
                      "installer"
                      "nvidia"
                      "amd"
                      "router"
                      "k3s"
                      "ipmi"
                      "forgejoRunner"
                      "nfsServer"
                      "cosmic"
                      "docker"
                    ];
                    defaultByHostType = {
                      desktop = [
                        "gui"
                        "hyprland"
                        "gaming"
                        "dev"
                        "docker"
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
        {
          pkgs,
          config,
          inputs',
          ...
        }:
        {
          formatter = pkgs.nixfmt-tree;
          pre-commit = {
            settings.hooks = {
              statix.enable = true;
              nixfmt-rfc-style.enable = true;
              commitizen.enable = true;
              shellcheck.enable = true;
              yamllint = {
                enable = true;
                settings = {
                  configPath = "./.yamllint";
                  strict = false;
                };
              };
              yamlfmt = {
                enable = true;
                settings.configPath = "./.yamlfmt";
              };
              markdownlint = {
                enable = true;
                settings.configuration = {
                  line-length = false;
                };
              };
            };
            check.enable = true;
          };
          devShells.default = pkgs.mkShell {
            shellHook = ''
              ${config.pre-commit.installationScript}
            '';
            packages = config.pre-commit.settings.enabledPackages ++ [
              inputs'.nixos-anywhere.packages.default
            ];
          };
        };
    };
}
