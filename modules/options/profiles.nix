{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.custom.profiles = {
    workstation.enable = mkEnableOption ''
      the Desktop profile

      This profile is intended for systems that are workstations: i.e
      systems that must contain a suite of applications tailored for
      daily usage, mainly for working, studying or programming.
    '';

  };
}
