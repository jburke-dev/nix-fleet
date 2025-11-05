{ delib, ... }:
delib.module {
  name = "networking.router";

  nixos.ifEnabled = {
    boot.kernel.sysctl = {
      "net.ipv4.conf.all.forwarding" = true;
      "net.ipv6.conf.all.forwarding" = true;

      # don't automatically configure ipv6 by default on interfaces
      "net.ipv6.conf.all.accept_ra" = 0;
      "net.ipv6.conf.all.autoconf" = 0;
      "net.ipv6.conf.all.use_tempaddr" = 0;

      # ...except on wan
      "net.ipv6.conf.wan.accept_ra" = 2;
      "net.ipv6.conf.wan.autoconf" = 1;
    };
  };
}
