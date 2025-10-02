{ delib, inputs, ... }:
delib.overlayModule {
  name = "claude-code";
  overlay = inputs.claude-code.overlays.default;
  enabled = true;
}
