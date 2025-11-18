{
  delib,
  host,
  pkgs,
  staticHosts,
  ...
}:
delib.module {
  name = "services.ipmi-exporter";

  options = delib.singleEnableOption host.ipmiFeatured;

  nixos.ifEnabled = {
    environment.systemPackages = with pkgs; [ freeipmi ];

    # Create ipmi group for device access
    users.groups.ipmi = { };

    # udev rule to give ipmi group access to IPMI devices
    services.udev.extraRules = ''
      KERNEL=="ipmi*", MODE="0660", GROUP="ipmi"
    '';

    services.prometheus.exporters.ipmi = {
      enable = true;
      listenAddress = staticHosts.${host.name};
      group = "ipmi";
    };

    # Override systemd hardening to allow device access
    systemd.services.prometheus-ipmi-exporter.serviceConfig = {
      PrivateDevices = false;
      DeviceAllow = [ "/dev/ipmi0 rw" ];
      SupplementaryGroups = [ "ipmi" ];
    };
  };
}
