{
  delib,
  ...
}:
delib.module {
  name = "services";

  options = with delib; readOnly (singleEnableOption true);
}
