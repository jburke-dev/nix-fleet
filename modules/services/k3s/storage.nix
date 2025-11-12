{ delib, host, ... }:
delib.module {
  name = "services.k3s";

  nixos.ifEnabled = {
    # from https://github.com/longhorn/longhorn/issues/2166#issuecomment-2994323945
    services.openiscsi = {
      enable = true;
      name = "${host.name}-initiatorhost";
    };
    # longhorn needs nfs client for ReadWriteMany volumes
    boot.supportedFilesystems = [ "nfs" ];
    systemd = {
      services.iscsid.serviceConfig = {
        PrivateMounts = "yes";
        BindPaths = "/run/current-system/sw/bin:/bin";
      };
      tmpfiles.rules = [
        "L /usr/bin/mount - - - - /run/current-system/sw/bin/mount"
      ];
    };
  };
}
