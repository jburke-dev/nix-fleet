{
  delib,
  lib,
  pkgs,
  ...
}:
let
  netLib = import ../../lib/networking.nix { inherit lib; };
in
delib.module {
  name = "networking.router";

  nixos.ifEnabled =
    let
      dhcpHostsFile = "/var/lib/kea/dhcp-hosts";
      staticHostsFile = "/etc/kea/static-hosts";
      keaHostsHook = pkgs.writeScript "kea-hosts-hook" ''
        #!${pkgs.bash}/bin/bash

        export PATH="${pkgs.coreutils}/bin:${pkgs.gnugrep}/bin:${pkgs.gnused}/bin:${pkgs.util-linux}/bin:$PATH"

        HOSTS_FILE="${dhcpHostsFile}"
        HOSTS_LOCK="/var/lib/kea/.hosts.lock"
        STATIC_HOSTS="${staticHostsFile}"

        (
          flock -x 200

          case "$KEA_LEASE4_TYPE" in
            lease4_select|lease4_renew)
              if [ -n "$LEASE4_HOSTNAME" ] && [ "$LEASE4_HOSTNAME" != "null" ]; then
                grep -v "^$LEASE4_ADDRESS " "$HOSTS_FILE" 2>/dev/null > "$HOSTS_FILE.tmp" || true
                mv -f "$HOSTS_FILE.tmp" "$HOSTS_FILE"
                echo "$LEASE4_ADDRESS $LEASE4_HOSTNAME $LEASE4_HOSTNAME.lan" >> "$HOSTS_FILE"
              fi
              ;;
            lease4_release|lease4_expire)
              grep -v "^$LEASE4_ADDRESS " "$HOSTS_FILE" 2>/dev/null > "$HOSTS_FILE.tmp" || true
              mv -f "$HOSTS_FILE.tmp" "$HOSTS_FILE"
              ;;
          esac

          cat "$STATIC_HOSTS" > "$HOSTS_FILE.new"
          if [ -f "$HOSTS_FILE" ]; then
            grep -v "^#" "$HOSTS_FILE" 2>/dev/null | grep -v "^$" | sort -u >> "$HOSTS_FILE.new" || true
          fi
          mv -f "$HOSTS_FILE.new" "$HOSTS_FILE"
        ) 200>"$HOSTS_LOCK"
      '';
    in
    { parent, ... }:
    {
      services = {
        kea = {
          dhcp4 = {
            enable = true;
            settings = {
              interfaces-config = {
                interfaces = [ "lan1" ];
              };

              valid-lifetime = 172800; # 48 hours
              max-valid-lifetime = 604800; # 7 days max
              renew-timer = 43200; # clients renew after 12 hours
              rebind-timer = 129600; # clients rebind after 36 hours
              decline-probation-period = 300; # 5 minutes

              # reservation options at subnet level take priority over the global ones
              reservations-global = false;
              reservations-in-subnet = false;

              host-reservation-identifiers = [ "hw-address" ];

              lease-database = {
                type = "memfile";
                persist = true;
                name = "/var/lib/kea/kea-leases4.csv";
                lfc-interval = 600;
                max-row-errors = 100;
              };

              expired-leases-processing = {
                reclaim-timer-wait-time = 900; # reclaim expired every 15 min
                hold-reclaimed-time = 900; # keep reclaimed for 15 mins before purging
                flush-reclaimed-timer-wait-time = 900;
                max-reclaim-leases = 500;
                max-reclaim-time = 500;
              };

              hooks-libraries = [
                {
                  library = "${pkgs.kea}/lib/kea/hooks/libdhcp_run_script.so";
                  parameters = {
                    name = "${keaHostsHook}";
                    sync = false;
                  };
                }
              ];
              subnet4 = lib.imap1 (
                idx: vlanName:
                let
                  vlan = parent.vlans.${vlanName};
                in
                {
                  id = idx;
                  subnet = netLib.vlanSubnet vlan;
                  option-data = [
                    {
                      name = "routers";
                      data = netLib.vlanGateway vlan;
                    }
                    {
                      name = "domain-name-servers";
                      data = netLib.vlanGateway vlan;
                    }
                    {
                      name = "domain-name";
                      data = parent.domain;
                    }
                  ];
                  reservations-global = false;
                  reservations-in-subnet = vlan.dhcpMode == "static";
                  reservations-out-of-pool = vlan.dhcpMode == "static";
                  reservations = lib.mapAttrsToList (hostName: hostCfg: {
                    hw-address = hostCfg.mac;
                    ip-address = netLib.getHostIp hostCfg;
                    hostname = hostName;
                  }) (lib.filterAttrs (_: host: host.vlanId == vlan.id) parent.staticHosts);
                  pools = [
                    {
                      pool = netLib.vlanDhcpPool vlan;
                    }
                  ];
                }
              ) (builtins.attrNames parent.vlans);
            };
          };
        };
        blocky.settings = {
          hostsFile = {
            sources = [ dhcpHostsFile ];
            hostsTTL = "30s";
            filterLoopback = false;
            loading = {
              refreshPeriod = "30s";
            };
          };
          customDNS = {
            customTTL = "1h";
            filterUnmappedTypes = true;
            mapping = lib.mkMerge (
              lib.flatten (
                lib.mapAttrsToList (name: host: {
                  "${name}" = netLib.getHostIp host;
                  "${name}.${parent.domain}" = netLib.getHostIp host;
                }) parent.staticHosts
              )
            );
          };
        };
      };

      systemd = {
        tmpfiles.rules = [
          "d /var/lib/kea 0755 kea kea -"
          "d /run/kea 0755 kea kea -"
          "C ${dhcpHostsFile} 0644 kea kea - ${staticHostsFile}"
        ];

        kea-dhcp4-server = {
          serviceConfig = {
            DynamicUser = lib.mkForce false;
            User = "kea";
            Group = "kea";
          };
        };
      };

      environment.etc."kea/static-hosts".text = ''
        # Static hosts
        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (
            hostname: hostCfg: "${netLib.getHostIp hostCfg} ${hostname} ${hostname}.${parent.domain}"
          ) parent.staticHosts
        )}
      '';

      users = {
        groups.kea = { };
        users.kea = {
          isSystemUser = true;
          group = "kea";
          description = "Kea DHCP daemon user";
        };
      };
    };
}
