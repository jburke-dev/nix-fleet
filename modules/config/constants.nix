{ delib, ... }:
delib.module {
  name = "constants";

  options.constants = with delib; {
    username = readOnly (strOption "jburke");
    userfullname = readOnly (strOption "Johan Burke");
    useremail = readOnly (strOption "jburke.create@gmail.com");
  };

  myconfig.always = { cfg, ... }: {
    args.shared.constants = cfg;
  };
}
