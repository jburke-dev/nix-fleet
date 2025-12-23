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
    { parent, cfg, ... }:
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

              valid-lifetime = 43200; # 12 hours
              max-valid-lifetime = 604800; # 7 days max
              renew-timer = 21600; # clients renew after 6 hours
              rebind-timer = 32400; # clients rebind after 9 hours
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
                reclaim-timer-wait-time = 3600; # reclaim expired every hour
                hold-reclaimed-time = 172800;
                flush-reclaimed-timer-wait-time = 3600;
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
                {
                  library = "${pkgs.kea}/lib/kea/hooks/libdhcp_lease_cmds.so";
                  parameters = { };
                }
              ];

              control-sockets = [
                {
                  "socket-type" = "http";
                  "socket-address" = netLib.vlanGateway allNetworks.lan;
                  "socket-port" = cfg.privilegedPorts.dhcp4ControlHttp;
                }
              ];
              subnet4 = lib.mapAttrsToList (networkName: network: {
                inherit (network) id;
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
                reservations-in-subnet = true;
                reservations-out-of-pool = true;
                reservations =
                  lib.mapAttrsToList
                    (hostName: hostCfg: {
                      hw-address = hostCfg.mac;
                      ip-address = netLib.getHostIpFromNetwork allNetworks hostCfg;
                      hostname = hostName;
                    })
                    (lib.filterAttrs (_: host: host.networkName == networkName && host.mac != "") parent.staticHosts);
                pools = [
                  {
                    pool = netLib.vlanDhcpPool network;
                  }
                ];
              }) allNetworks;
              loggers = [
                {
                  name = "kea-dhcp4";
                  output-options = [
                    {
                      output = "/var/log/kea/kea-dhcp4.log";
                      maxsize = 2048000; # 2 MB
                      maxver = 4;
                    }
                  ];
                  severity = "INFO";
                  debuglevel = 0;
                }
              ];
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

              control-sockets = [
                {
                  "socket-type" = "http";
                  "socket-address" = netLib.vlanGateway allNetworks.lan;
                  "socket-port" = cfg.privilegedPorts.dhcp6ControlHttp;
                }
              ];
              hooks-libraries = [
                {
                  library = "${pkgs.kea}/lib/kea/hooks/libdhcp_run_script.so";
                  parameters = {
                    name = "${keaHostsHook}";
                    sync = false;
                  };
                }
                {
                  library = "${pkgs.kea}/lib/kea/hooks/libdhcp_lease_cmds.so";
                  parameters = { };
                }
              ];

              subnet6 = lib.mapAttrsToList (networkName: network: {
                inherit (network) id;
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
              }) allNetworks;
            };
          };
        };
        blocky.settings = {
          hostsFile = {
            sources = [ staticHostsFile ];
            hostsTTL = "30s";
            filterLoopback = false;
            loading = {
              refreshPeriod = "30s";
            };
          };
        };
      };

      systemd = {
        tmpfiles.rules = [
          "d /var/lib/kea 0755 kea kea -"
          "d /var/log/kea 0755 kea kea -"
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
          ) (lib.filterAttrs (host: hostCfg: hostCfg.addToStaticHostsFile) parent.staticHosts)
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
