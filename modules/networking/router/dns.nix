{ delib, pkgs, ... }:
delib.module {
  name = "networking.router";

  nixos.ifEnabled =
    { cfg, ... }:
    {
      services.blocky = {
        enable = true;
        settings = {
          ports = {
            dns = [
              53
            ];
            http = [
              4000
            ];
          };
          # TODO: add another provider besides cloudflare!!
          bootstrapDns = [
            {
              upstream = "1.1.1.1";
            }
            {
              upstream = "1.0.0.1";
            }
            {
              upstream = "2606:4700:4700::1111";
            }
            {
              upstream = "2606:4700:4700::1001";
            }
          ];
          connectIPVersion = "dual";
          upstreams = {
            groups = {
              default = [
                "1.1.1.1"
                "1.0.0.1"
                "2606:4700:4700::1111"
                "2606:4700:4700::1001"
              ];
            };
          };
          customDNS = {
            customTTL = "1h";
            filterUnmappedTypes = true;
          };
          blocking = {
            denylists = {
              ads = [
                "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
                "https://someonewhocares.org/hosts/zero/hosts"
                "https://raw.githubusercontent.com/bigdargon/hostsVN/master/hosts"
              ];
              tracking = [
                "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt"
                "https://hostfiles.frogeye.fr/firstparty-trackers-hosts.txt"
                "https://raw.githubusercontent.com/neodevpro/neodevhost/master/host"
              ];
              telemetry = [
                "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt"
                "https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/android-tracking.txt"
                "https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/AmazonFireTV.txt"
                "https://raw.githubusercontent.com/0Zinc/easylists-for-pihole/master/easyprivacy.txt"
                "https://v.firebog.net/hosts/Prigent-Ads.txt"
              ];
              malware = [
                "https://urlhaus.abuse.ch/downloads/hostfile/"
                "https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-malware.txt"
              ];
            };
            clientGroupsBlock = {
              default = [
                "ads"
                "tracking"
                "telemetry"
                "malware"
              ];
            };
          };
        };
      };
      systemd.services.blocky = {
        after = [
          "network-online.target"
          "nftables.service"
        ];
        wants = [ "network-online.target" ];
        serviceConfig = {
          ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
        };
      };
    };
}
