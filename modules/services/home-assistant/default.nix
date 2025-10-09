{
  delib,
  host,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "services.home-assistant";

  options =
    with delib;
    moduleOptions (
      { parent, ... }:
      {
        enable = boolOption host.homeAssistantFeatured;
        listenAddress = strOption parent.hostVlans.iot.address;
        interface = strOption parent.hostVlans.iot.netdevName;
      }
    );

  nixos.ifEnabled =
    { cfg, myconfig, ... }:
    {
      services.home-assistant = {
        enable = true;
        extraComponents = [
          "zha"
          "homeassistant_hardware"
        ];
        config = {
          http = {
            server_host = [ cfg.listenAddress ];
            trusted_proxies = [ myconfig.constants.traefikVip ] ++ myconfig.constants.traefikInstances;
            use_x_forwarded_for = true;
          };
          # Manual config instead of default_config to exclude Bluetooth integrations
          application_credentials = { };
          assist_pipeline = { };
          automation = { };
          backup = { };
          cloud = { };
          config = { };
          counter = { };
          diagnostics = { };
          dhcp = { };
          energy = { };
          frontend = { };
          hardware = { };
          history = { };
          homeassistant_alerts = { };
          image_upload = { };
          input_boolean = { };
          input_button = { };
          input_datetime = { };
          input_number = { };
          input_select = { };
          input_text = { };
          logbook = { };
          logger = { };
          media_source = { };
          mobile_app = { };
          my = { };
          network = { };
          person = { };
          scene = { };
          script = { };
          schedule = { };
          ssdp = { };
          stream = { };
          sun = { };
          system_health = { };
          tag = { };
          timer = { };
          usb = { };
          webhook = { };
          zone = { };
          zeroconf = { };
          # Explicitly exclude: bluetooth, bluetooth_adapters
        };
      };

      networking.firewall.interfaces."${cfg.interface}".allowedTCPPorts = [ 8123 ];
    };
}
