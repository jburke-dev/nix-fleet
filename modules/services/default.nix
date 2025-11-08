{
  delib,
  ...
}:
delib.module {
  name = "services";

  options =
    with delib;
    moduleOptions {
      enable = readOnly (boolOption true);
    };
}
