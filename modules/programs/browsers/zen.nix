{
  delib,
  inputs,
  host,
  ...
}:
delib.module {
  name = "programs.browsers.zen";
  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled = {
    imports = [ inputs.zen-browser.homeModules.twilight ];

    programs.zen-browser = {
      enable = true;
      policies =
        let
          mkLockedAttrs = builtins.mapAttrs (
            _: value: {
              Value = value;
              Status = "locked";
            }
          );
        in
        {
          AutofillAddressEnabled = false;
          AutofillCreditCardEnabled = false;
          DisableAppUpdate = true;
          DisableFeedbackCommands = true;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DontCheckDefaultBrowser = true;
          OfferToSaveLogins = false;
          NoDefaultBookmarks = true;
          Preferences = mkLockedAttrs {
            "browser.aboutConfig.showWarning" = false;
            "browser.tabs.warnOnClose" = false;
            "media.videocontrols.picture-in-picture.video-toggle.enabled" = true;
            "browser.gesture.swipe.left" = "";
            "browser.gesture.swipe.right" = "";
            "browser.tabs.hoverPreview.enabled" = true;
            "browser.newtabpage.activity-stream.feeds.topsites" = false;
            "browser.topsites.contile.enabled" = false;
            "privacy.resistFingerprinting" = true;
            "privacy.firstparty.isolate" = true;
            "network.cookie.cookieBehavior" = 5;
            "gfx.webrender.all" = true;
          };
        };
    };
  };
}
