{ delib, ... }:
delib.module {
  name = "constants";

  options.constants = with delib; {
    username = readOnly (strOption "jburke");
    userFullName = readOnly (strOption "Johan Burke");
    userEmail = readOnly (strOption "jburke.create@gmail.com");
  };

  myconfig.always =
    { cfg, ... }:
    {
      args.shared.constants = cfg;
    };
}
