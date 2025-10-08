#!/usr/bin/env bash
# Generate default.nix for a host
# Usage: output-host-config --hostname NAME

set -euo pipefail

HOSTNAME=
HARDWARE_CONFIG=/mnt/etc/nixos/hardware-configuration.nix

while [ $# -gt 0 ]; do
  case "$1" in
    --hostname)
      HOSTNAME="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
done

validate_args() {
  if [ -z "$HOSTNAME" ]; then
    echo "Error: Missing required argument --hostname" >&2
    echo "Usage: output-host-config --hostname NAME" >&2
    exit 1
  fi

  if [[ ! -e flake.nix || ! -d "./hosts/$HOSTNAME" ]]; then
    echo "Error: Flake missing" >&2
    echo "Did you run this in the right directory?" >&2
    exit 1
  fi

  if [[ ! -e "$HARDWARE_CONFIG" ]]; then
    echo "Error: Hardware configuration missing" >&2
    echo "Did you mount the root partition and generate the nixos config?" >&2
    exit 1
  fi
}

validate_args
cat <<EOF > "./hosts/$HOSTNAME/default.nix"
{ delib, ... }:
delib.host {
  name = "$HOSTNAME";

  type = "server";

  features = [ ];
}
EOF

cat <<EOF > "./hosts/$HOSTNAME/networking.nix"
{ delib, ... }:
delib.host {
  name = "$HOSTNAME";

  nixos = {
    networking = {
      hostId = "$(head -c 4 /dev/urandom | od -A n -t x4 | tr -d ' ')";

      firewall.interfaces = {
        # update to appropriate interface
        # "vlan-mgmt".allowedTCPPorts = [ 22 ];
      };
    };
  };

  myconfig.networking.systemd.vlans = {
    # update to appropriate vlans
    /*
    mgmt = {
      interface = <MGMT_INTERFACE>;
      hostIp = <MGMT_HOST_IP>;
      isDefault = true;
      metric = 100;
    };
    services = {
      interface = <SERVICES_INTERFACE>;
      hostIp = <SERVICES_HOST_IP>;
      metric = 200;
      routingTable = 101;
    };
    */
  };
}
EOF

cat <<EOF > "./hosts/$HOSTNAME/hardware.nix"
{ delib, ... }:
delib.host {
  name = "$HOSTNAME";
  system = "x86_64-linux";

  homeManagerSystem = "x86_64-linux";
  home.home.stateVersion = "25.11";

  nixos = {
    // fill in with generated contents
  };
}
EOF

cp "$HARDWARE_CONFIG" "./hosts/$HOSTNAME/hardware-configuration.nix"
echo "<EDIT ME>" >> "./hosts/$HOSTNAME/hardware-configuration.nix"
