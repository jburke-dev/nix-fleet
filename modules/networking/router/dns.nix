{ delib, pkgs, ... }:
delib.module {
  name = "networking.router";

  nixos.ifEnabled =
    { cfg, ... }:
    {
      services.blocky = {
        enable = true;
        ports = {
          dns = [
            53
          ];
          http = [
            4000
          ];
        };
        bootstrapDns = [
          {
            upstream = "1.1.1.1";
            ips = [ "1.1.1.1" ];
          }
          {
            upstream = "1.0.0.1";
            ips = [ "1.0.0.1" ];
          }
        ];
        connectIPVersion = "v4";
        upstreams = {
          groups = {
            default = [
              "1.1.1.1"
              "1.0.0.1"
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
