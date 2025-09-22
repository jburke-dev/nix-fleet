{
  delib,
  inputs,
  host,
  ...
}:
delib.module {
  name = "programs.zen-browser";

  options = delib.singleEnableOption host.guiFeatured;

  home.always.imports = [ inputs.zen-browser.homeModules.twilight ];

  home.ifEnabled.programs.zen-browser.enable = true;
}
