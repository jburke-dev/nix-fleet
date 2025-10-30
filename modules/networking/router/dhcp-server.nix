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

          # Handle DHCPv4 events
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

          # Handle DHCPv6 events
          case "$KEA_LEASE6_TYPE" in
            lease6_select|lease6_renew)
              if [ -n "$LEASE6_HOSTNAME" ] && [ "$LEASE6_HOSTNAME" != "null" ]; then
                grep -v "^$LEASE6_ADDRESS " "$HOSTS_FILE" 2>/dev/null > "$HOSTS_FILE.tmp" || true
                mv -f "$HOSTS_FILE.tmp" "$HOSTS_FILE"
                echo "$LEASE6_ADDRESS $LEASE6_HOSTNAME $LEASE6_HOSTNAME.lan" >> "$HOSTS_FILE"
              fi
              ;;
            lease6_release|lease6_expire)
              grep -v "^$LEASE6_ADDRESS " "$HOSTS_FILE" 2>/dev/null > "$HOSTS_FILE.tmp" || true
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
    let
      allNetworks = parent.networks;
    in
    {
      services = {
        kea = {
          dhcp4 = {
            enable = true;
            settings = {
              interfaces-config = {
                interfaces = builtins.map (name: netLib.getNetworkInterface name allNetworks.${name}) (
                  builtins.attrNames allNetworks
                );
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
                idx: networkName:
                let
                  network = allNetworks.${networkName};
                in
                {
                  id = idx;
                  subnet = netLib.vlanSubnet network;
                  interface = netLib.getNetworkInterface networkName network;
                  option-data = [
                    {
                      name = "routers";
                      data = netLib.vlanGateway network;
                    }
                    {
                      name = "domain-name-servers";
                      data = netLib.vlanGateway network;
                    }
                    {
                      name = "domain-name";
                      data = parent.domain;
                    }
                  ];
                  reservations-global = false;
                  reservations-in-subnet = network.dhcpMode == "static";
                  reservations-out-of-pool = network.dhcpMode == "static";
                  reservations = lib.mapAttrsToList (hostName: hostCfg: {
                    hw-address = hostCfg.mac;
                    ip-address = netLib.getHostIpFromNetwork allNetworks hostCfg;
                    hostname = hostName;
                  }) (lib.filterAttrs (_: host: host.networkName == networkName) parent.staticHosts);
                  pools = [
                    {
                      pool = netLib.vlanDhcpPool network;
                    }
                  ];
                }
              ) (builtins.attrNames allNetworks);
            };
          };
          dhcp6 = {
            enable = true;
            settings = {
              interfaces-config = {
                interfaces = builtins.map (name: netLib.getNetworkInterface name allNetworks.${name}) (
                  builtins.attrNames allNetworks
                );
              };

              preferred-lifetime = 1800; # 30 minutes
              valid-lifetime = 3600; # 1 hour
              renew-timer = 900; # 15 minutes
              rebind-timer = 1350; # 22.5 minutes

              lease-database = {
                type = "memfile";
                persist = true;
                name = "/var/lib/kea/kea-leases6.csv";
                lfc-interval = 600;
                max-row-errors = 100;
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

              subnet6 = lib.imap1 (
                idx: networkName:
                let
                  network = allNetworks.${networkName};
                in
                {
                  id = idx;
                  subnet = netLib.vlanSubnetV6 network;
                  interface = netLib.getNetworkInterface networkName network;
                  option-data = [
                    {
                      name = "dns-servers";
                      data = netLib.vlanGatewayV6 network;
                    }
                    {
                      name = "domain-search";
                      data = parent.domain;
                    }
                  ];
                }
              ) (builtins.attrNames allNetworks);
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
                  "${name}" = [
                    (netLib.getHostIpFromNetwork allNetworks host)
                    (netLib.getHostIpV6FromNetwork allNetworks host)
                  ];
                  "${name}.${parent.domain}" = [
                    (netLib.getHostIpFromNetwork allNetworks host)
                    (netLib.getHostIpV6FromNetwork allNetworks host)
                  ];
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

        services = {
          kea-dhcp4-server = {
            serviceConfig = {
              DynamicUser = lib.mkForce false;
              User = "kea";
              Group = "kea";
            };
          };
          kea-dhcp6-server = {
            serviceConfig = {
              DynamicUser = lib.mkForce false;
              User = "kea";
              Group = "kea";
            };
          };
        };
      };

      environment.etc."kea/static-hosts".text = ''
        # Static hosts
        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (
            hostname: hostCfg:
            "${netLib.getHostIpFromNetwork allNetworks hostCfg} ${hostname} ${hostname}.${parent.domain}"
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
