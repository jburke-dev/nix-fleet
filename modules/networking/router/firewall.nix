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
    { parent, ... }:
    let
      allNetworks = parent.networks;

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
        in
        ''
          chain from_${networkName} {
          ${allowRules}
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

              # Allow SSH from trusted networks (add specific network names as needed)
              iifname "vlan-trusted" tcp dport 22 accept;
              iifname "br-lan" tcp dport 22 accept;

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
              # log prefix "FORWARD DROP: " drop;
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
