{
  delib,
  config,
  lib,
  pkgs,
  ...
}:
delib.module {
  name = "services.media.protonvpn";

  options = delib.singleCascadeEnableOption;

  nixos.ifEnabled = {
    sops.secrets.protonvpn_private_key = {
      restartUnits = [ "netns-protonvpn.service" ];
    };

    # WireGuard interface in dedicated network namespace
    networking.wireguard.interfaces.protonvpn0 = {
      ips = [ "10.2.0.2/32" ];
      privateKeyFile = config.sops.secrets.protonvpn_private_key.path;

      # Run WireGuard in its own network namespace for isolation
      interfaceNamespace = "protonvpn";

      peers = [
        {
          publicKey = "Orm/o/kOBbNLCvxrwdQZHswlHRyz4O8HSaCHJ7YF0Rs=";
          endpoint = "146.70.202.18:51820";
          allowedIPs = [ "0.0.0.0/0" ];
          persistentKeepalive = 25;
        }
      ];
    };

    # Systemd service to create and configure the network namespace
    systemd.services.netns-protonvpn = {
      description = "Create ProtonVPN network namespace";
      before = [ "wireguard-protonvpn0.service" ];
      requiredBy = [ "wireguard-protonvpn0.service" ];
      wantedBy = [ "multi-user.target" ];

      path = with pkgs; [ iproute2 ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = ''
        # Create namespace if it doesn't exist
        ip netns add protonvpn || true

        # Bring up loopback in namespace
        ip -n protonvpn link set lo up

        # Configure DNS for the namespace (ProtonVPN DNS server)
        mkdir -p /etc/netns/protonvpn
        echo "nameserver 10.2.0.1" > /etc/netns/protonvpn/resolv.conf
      '';

      preStop = ''
        ip netns del protonvpn || true
      '';
    };
  };
}
