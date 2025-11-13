{
  delib,
  lib,
  ...
}:
let
  netLib = import ../../lib/networking.nix { inherit lib; };
in
delib.module {
  name = "networking.router";

  nixos.ifEnabled =
    { parent, cfg, ... }:
    let
      allNetworks = parent.networks;
      trustedNetworks = lib.filterAttrs (n: v: v.firewall.isTrusted) allNetworks;
      privilegedPortString = lib.concatMapStringsSep ", " toString (
        builtins.attrValues cfg.privilegedPorts
      );
      # TODO: pattern of concatMapStringsSep with iifname could probably be pulled out into a function
      privilegedPortRules = lib.concatMapStringsSep "\n" (
        networkName:
        let
          network = allNetworks.${networkName};
          iface = netLib.getNetworkInterface networkName network;
        in
        "    iifname \"${iface}\" tcp dport { ${privilegedPortString} } accept;"
      ) (builtins.attrNames trustedNetworks);

      # Generate a firewall chain for a network
      mkNetworkChain =
        networkName: network:
        let
          # Generate rules for allowed outbound destinations
          allowRules = lib.concatMapStringsSep "\n" (
            dest:
            if dest == "wan" then
              "    oifname \"wan\" accept;"
            else
              let
                destIface = netLib.getNetworkInterface dest allNetworks.${dest};
              in
              "    oifname \"${destIface}\" accept;"
          ) network.firewall.allowOutbound;

          # Generate rules for IP-specific port access
          ipPortRules = lib.concatMapStringsSep "\n" (
            rule:
            let
              portList = lib.concatMapStringsSep ", " toString rule.ports;
              protocols =
                if rule.protocol == "both" then
                  [
                    "tcp"
                    "udp"
                  ]
                else
                  [ rule.protocol ];
              protoRules = lib.concatMapStringsSep "\n" (
                proto: "    ip daddr ${rule.ip} ${proto} dport { ${portList} } accept;"
              ) protocols;
            in
            protoRules
          ) network.firewall.allowOutboundToIp;
        in
        ''
          chain from_${networkName} {
          ${allowRules}
          ${ipPortRules}
          log prefix "[nftables] from_${networkName} denied: " counter drop;
          }
        '';

      # Generate jump rules for the forward chain
      forwardJumps = lib.concatMapStringsSep "\n" (
        networkName:
        let
          network = allNetworks.${networkName};
          iface = netLib.getNetworkInterface networkName network;
        in
        "    iifname \"${iface}\" jump from_${networkName};"
      ) (builtins.attrNames allNetworks);

      # Generate all network chains
      networkChains = lib.concatMapStringsSep "\n" (
        networkName: mkNetworkChain networkName allNetworks.${networkName}
      ) (builtins.attrNames allNetworks);

    in
    {
      networking.nftables = {
        enable = true;
        ruleset = ''
          table inet filter {
            # MSS clamping for PMTU discovery - prevents TCP hangs.  This was preventing terminal emulators from successfully copying terminfo on first ssh
            chain forward_mss {
              type filter hook forward priority -150;
              tcp flags syn tcp option maxseg size set rt mtu;
            }

            chain input {
              type filter hook input priority 0; policy drop;

              # Allow established/related connections
              ct state established,related accept;
              ct state invalid counter drop;

              # Allow loopback
              iifname "lo" accept;

              # Allow ICMPv4 and ICMPv6
              ip protocol icmp accept;
              ip6 nexthdr icmpv6 accept;

              # Allow DHCPv4 and DHCPv6 from all networks
              ${lib.concatMapStringsSep "\n" (
                networkName:
                let
                  iface = netLib.getNetworkInterface networkName allNetworks.${networkName};
                in
                "    iifname \"${iface}\" udp dport { 53, 67, 547 } accept;"
              ) (builtins.attrNames allNetworks)}
              ${lib.concatMapStringsSep "\n" (
                networkName:
                let
                  iface = netLib.getNetworkInterface networkName allNetworks.${networkName};
                in
                "    iifname \"${iface}\" tcp dport 53 accept;"
              ) (builtins.attrNames allNetworks)}

              # allow trusted networks access to privileged ports
              ${privilegedPortRules}

              # Log and drop everything else
              # log prefix "INPUT DROP: " drop;
            }

            chain forward {
              type filter hook forward priority 0; policy drop;

              # Allow established/related connections
              ct state established,related accept;
              ct state invalid counter drop;

              # Jump to per-network chains based on input interface
              ${forwardJumps}

              # Log and drop everything else
              log prefix "[nftables] forward denied: " counter drop;
            }

            # Per-network chains
            ${networkChains}
          }

          table ip nat {
            chain prerouting {
              type nat hook prerouting priority 0;
            }

            chain postrouting {
              type nat hook postrouting priority 0;
              oifname "wan" masquerade;
            }
          }

          table ip6 nat {
            chain prerouting {
              type nat hook prerouting priority 0;
            }

            chain postrouting {
              type nat hook postrouting priority 0;
              # IPv6 typically doesn't need NAT with proper addressing
              # oifname "wan" masquerade;
            }
          }
        '';
      };
    };
}
