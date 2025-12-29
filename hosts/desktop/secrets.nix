{ delib, ... }:
delib.host {
  name = "desktop";

  myconfig.secrets = {
    defaultSopsFile = ./secrets.yaml;
    sshKeyPaths = [ "/mnt/apps/ssh/id_sops" ];
    secrets = {
      "terraform.yaml" = {
        format = "yaml";
        sopsFile = ./secrets/terraform.yaml;
        key = "";
      };
    };
  };
}
