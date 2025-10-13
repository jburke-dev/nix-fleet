{
  delib,
  config,
  lib,
  pkgs,
  ...
}:
delib.module {
  name = "services.media.deluge";

  options = delib.singleCascadeEnableOption;

  nixos.ifEnabled = {
    # Deluge daemon runs in the VPN namespace
    services.deluge = {
      enable = true;
      web.enable = true;
      dataDir = "/mnt/databases/deluge";
      user = "media";
      group = "media";
    };

    # Run deluged in the VPN namespace
    systemd = {
      services = {
        deluged = {
          bindsTo = [ "netns-protonvpn.service" ];
          after = [
            "netns-protonvpn.service"
            "wireguard-protonvpn0.service"
          ];
          serviceConfig = {
            NetworkNamespacePath = "/run/netns/protonvpn";
          };

        };

        proxy-to-deluged = {
          description = "Proxy to Deluge Daemon in VPN namespace";
          requires = [
            "proxy-to-deluged.socket"
            "deluged.service"
          ];
          after = [
            "proxy-to-deluged.socket"
            "deluged.service"
          ];

          serviceConfig = {
            # Run the proxy in the VPN namespace so it can reach deluged on localhost
            NetworkNamespacePath = "/run/netns/protonvpn";
            ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd 127.0.0.1:58846";
            PrivateTmp = true;
          };
        };
        deluge-web.after = [ "proxy-to-deluged.service" ];

      };

      # Socket proxy to bridge deluge-web (root namespace) to deluged (VPN namespace)
      sockets.proxy-to-deluged = {
        description = "Socket for Proxy to Deluge Daemon";
        wantedBy = [ "sockets.target" ];
        listenStreams = [ "127.0.0.1:58846" ];
        socketConfig = {
          FreeBind = true;
          Accept = false;
        };
      };
    };

    # Open firewall for deluge web UI
    networking.firewall.allowedTCPPorts = [ 8112 ];
  };
}
