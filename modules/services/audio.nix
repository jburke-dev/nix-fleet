{
    delib,
    host,
    ...
}:
delib.module {
    name = "services.audio";

    options = delib.singleEnableOption host.isPC;

    nixos.ifEnabled = {
        services.pulseaudio.enable = false;
        security.rtkit.enable = true;
        services.pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
        };
    };
}
