{
  delib,
  config,
  pkgs,
  ...
}:
let
  # Script to update Deluge port from ProtonVPN NAT-PMP
  updatePortScript = pkgs.writeShellScript "update-deluge-port" ''
    set -e

    # Run natpmpc inside the VPN namespace to get the forwarded port
    VPN_PORT=$(${pkgs.iproute2}/bin/ip netns exec protonvpn ${pkgs.libnatpmp}/bin/natpmpc -a 0 0 udp 60 -g 10.2.0.1 2>/dev/null | ${pkgs.gnugrep}/bin/grep "Mapped public port" | ${pkgs.gawk}/bin/awk '{print $4}')

    if [ -z "$VPN_PORT" ]; then
      echo "Failed to get port from ProtonVPN NAT-PMP"
      exit 1
    fi

    echo "ProtonVPN forwarded port: $VPN_PORT"

    # Update Deluge listening port using deluge-console
    ${pkgs.iproute2}/bin/ip netns exec protonvpn ${pkgs.deluge}/bin/deluge-console "config --set listen_ports ($VPN_PORT,$VPN_PORT)"

    echo "Updated Deluge port to $VPN_PORT"
  '';
in
delib.module {
  name = "services.media.port-forward";

  options = delib.singleCascadeEnableOption;

  nixos.ifEnabled = {
    environment.systemPackages = with pkgs; [ libnatpmp ];
    # Systemd timer to periodically update port
    systemd.timers.deluge-port-forward = {
      description = "Update Deluge port from ProtonVPN";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*:0/5"; # Every 5 minutes
        Persistent = true;
      };
    };

    systemd.services.deluge-port-forward = {
      description = "Update Deluge port from ProtonVPN NAT-PMP";
      after = [
        "deluged.service"
        "wireguard-protonvpn0.service"
      ];
      wants = [ "network-online.target" ];
      requires = [
        "deluged.service"
        "wireguard-protonvpn0.service"
      ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = updatePortScript;
        User = "root";
      };
    };
  };
}
