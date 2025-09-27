{
  delib,
  inputs,
  ...
}:
delib.module {
  name = "stylix";

  #home.always.imports = [ inputs.stylix.homeModules.stylix ];
  nixos.always.imports = [ inputs.stylix.nixosModules.stylix ];
}
