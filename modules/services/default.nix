{
  delib,
  ...
}:
delib.module {
  name = "services";

  options =
    with delib;
    moduleOptions {
      hostVlans = attrsOfOption (submodule (
        { config, ... }:
        {
          options = {
            netdevName = strOption "";
            address = strOption "";
          };
        }
      )) { };
    };
}
