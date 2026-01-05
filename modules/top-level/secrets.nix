{
  delib,
  inputs,
  ...
}:
delib.module {
  name = "secrets";

  options.secrets = with delib; {
    defaultSopsFile = pathOption ../../secrets.yaml;
    sshKeyPaths = listOfOption str [
      "/etc/ssh/ssh_host_ed25519_key"
    ];
    secrets = attrsOfOption attrs { };
  };

  home.always =
    { cfg, ... }:
    {
      imports = [ inputs.sops-nix.homeManagerModules.sops ];
      sops = {
        inherit (cfg) secrets defaultSopsFile;
        age = { inherit (cfg) sshKeyPaths; };
      };
    };

  nixos.always =
    { cfg, ... }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];
      sops = {
        inherit (cfg) secrets defaultSopsFile;
        age = { inherit (cfg) sshKeyPaths; };
      };
    };
}
