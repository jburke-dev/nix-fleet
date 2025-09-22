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
  };

  outputs =
    {
      denix,
      flake-parts,
      nixpkgs-unstable,
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
              ];

              extensions = with denix.lib.extensions; [
                args
                (base.withConfig {
                  args.enable = true;
                  rices.enable = false;
                  hosts.features = {
                    features = [
                      "cli"
                      "gui"
                      "gaming"
                      "dev"
                      "dhcpClient"
                      "installer"
                    ];
                    defaultByHostType = {
                      desktop = [
                        "cli"
                        "gui"
                        "gaming"
                        "dev"
                        "dhcpClient"
                      ];
                      server = [ ];
                      laptop = [
                        "cli"
                        "gui"
                        "dev"
                        "dhcpClient"
                      ];
                    };
                  };
                })
              ];

              specialArgs = {
                inherit inputs moduleSystem nixpkgs-unstable;
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
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [ just ];
          };

          formatter = pkgs.nixfmt-tree;
        };
    };
}
