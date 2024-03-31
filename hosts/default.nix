{ withSystem, inputs, self, ... }:
let
  # self.lib is an extended version of nixpkgs.lib
  # mkNixosIso and mkNixosSystem are my own builders for assembling a nixos system
  # provided by my local extended library
  inherit (inputs.self) lib;
  inherit (lib) concatLists mkNixosIso mkNixosSystem;

  ## flake inputs ##
  hm = inputs.home-manager.nixosModules.home-manager; # home-manager nixos module

  # serializing the modulePath to a variable
  # this is in case the modulePath changes depth (i.e modules becomes nixos/modules)
  modulePath = ../modules;

  coreModules = modulePath + /core; # the path where common modules reside
  extraModules = modulePath + /extra; # the path where extra modules reside
  options = modulePath + /options; # the module that provides the options for my system configuration

  # common modules
  # to be shared across all systems without exception
  common = coreModules + /common; # the self-proclaimed sane defaults for all my systems
  sharedModules = extraModules + /shared; # the path where shared modules reside

  # home-manager #
  homesDir = ../homes; # home-manager configurations for hosts that need home-manager
  homes = [ hm homesDir ]; # combine hm flake input and the home module to be imported together

  # a list of shared modules that ALL systems need
  shared = [
    common # the "sane" default shared across systems
    sharedModules # consume my flake's own nixosModules
    options # provide options for defined modules across the system
  ];
in
{
  winder = mkNixosSystem {
    inherit withSystem;
    hostname = "winder";
    system = "x86_64-linux";
    specialArgs = {
      inherit inputs;
      asztal = self.packages.x86_64-linux.default;
    };
    modules = [
      ./pc/configuration.nix
    ]
    ++ concatLists [ shared homes ];
  };

  winder-laptop = mkNixosSystem {
    inherit withSystem;
    hostname = "winder";
    system = "x86_64-linux";
    specialArgs = {
      inherit inputs;
      asztal = self.packages.x86_64-linux.default;
    };
    modules = [
      ./laptop/configuration.nix
    ]
    ++ concatLists [ shared homes ];
  };
}
