{ inputs, ... }:
let
  inherit (inputs.nixpkgs) lib;

  # Custom library extending nixpkgs.lib. All custom functions are under
  # `lib.extendedLib.*` and also pulled into the top-level `lib.*` for convenience.
  nyxLib = self:
    let
      libArgs = { inherit inputs; lib = self; };
    in
    {
      extendedLib = {
        builders = import ./builders.nix libArgs;
        hardware = import ./hardware.nix libArgs;
        modules = import ./modules.nix libArgs;
        systemd = import ./systemd.nix libArgs;
        themes = import ./themes.nix libArgs;
      };

      xdgTemplate = ./xdg.nix;

      inherit (self.extendedLib.builders) mkSystem mkNixosSystem;
      inherit (self.extendedLib.hardware) isx86Linux primaryMonitor;
      inherit (self.extendedLib.modules) mkService mkModuleTree mkModuleTree' importPathOrTree;
      inherit (self.extendedLib.systemd) hardenService mkGraphicalService mkHyprlandService;
      inherit (self.extendedLib.themes) serializeTheme compileSCSS;
    };

  extensions = lib.composeManyExtensions [
    (_: _: inputs.nixpkgs.lib)
    (_: _: inputs.flake-parts.lib)
  ];

  # Extend default library
  extendedLibrary = (lib.makeExtensible nyxLib).extend extensions;
in
{
  perSystem = {
    # Set the `lib` arg of the flake as the extended lib. If I am right, this should
    # override the previous argument (i.e. the original nixpkgs.lib, provided by flake-parts
    # as a reasonable default) with my own, which is the same nixpkgs library, but actually extended
    # with my own custom functions.
    _module.args.lib = extendedLibrary;
  };

  flake = {
    # Also set `lib` as a flake output, which allows for it to be referenced outside
    # the scope of this flake. This is useful for when I want to refer to my extended
    # library from outside this flake, or if someone wants to access my functions
    # but that rarely happens, Ctrl+C and Ctrl+V is the developer way it seems.
    lib = extendedLibrary;
  };
}
