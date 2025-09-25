{
  delib,
  ...
}:
delib.module {
  name = "services";

  # TODO: not sure why this isn't working
  /*
    options =
      with delib;
      moduleOptions {
        listenAddress = noDefault (strOption null);
        interface = noDefault (strOption null);
      };
  */
}
