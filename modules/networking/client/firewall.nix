{ delib, host, ... }:
delib.module {
  name = "networking.client.firewall";

  options = delib.singleEnableOption host.isPC;

  nixos.ifEnabled = {
    networking.nftables = {
      enable = true;
      # accept localhost traffic, traffic originating from the client itself, and ipv6 neighbor discovery, otherwise drop
      # taken directly from nftables wiki: https://wiki.nftables.org/wiki-nftables/index.php/Simple_ruleset_for_a_workstation
      ruleset = ''
        table inet filter {
          chain input {
            type filter hook input priority 0; policy drop;

            iif lo accept

            ct state established,related accept

            icmpv6 type { nd-neighbor-solicit, nd-router-advert, nd-neighbor-advert } accept
          }
        }
      '';
    };
  };
}
