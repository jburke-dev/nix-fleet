{ delib, lib, ... }:
delib.module {
  name = "networking.tests";

  options =
    with delib;
    moduleOptions (
      { parent, ... }:
      {
        enable = boolOption parent.enable;
        /*
          TODO??
          unitTests = readOnly (
            attrsOfOption (submodule {
              options = {
                expectedValue = anythingOption "";
              };
            }) { }
          );
        */
      }
    );

  nixos.ifEnabled =
    let
      netLib = import ../lib/networking.nix { inherit lib; };
    in
    {
      assertions = [
        {
          assertion = (netLib.vlanIp { id = 12; } "0.1") == "10.12.0.1";
          message = "netLib vlanIp failed sanity check!";
        }
        {
          assertion = (netLib.vlanGateway { id = 12; }) == "10.12.0.1";
          message = "netLib vlanGateway failed sanity check!";
        }
      ];
    };
}
