{
  delib,
  inputs,
  ...
}:
let
  sops = {
    defaultSopsFile = ../../secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };
in
delib.module {
  name = "secrets";

  options.secrets = with delib; {
    secrets = attrsOfOption attrs { };
    templates = attrsOfOption attrs { };
  };

  home.always =
    { cfg, ... }:
    {
      imports = [ inputs.sops-nix.homeManagerModules.sops ];
      sops = sops // {
        inherit (cfg) secrets;
      };
    };

  nixos.always =
    { cfg, ... }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];
      sops = sops // {
        inherit (cfg) secrets;
      };
    };
}
