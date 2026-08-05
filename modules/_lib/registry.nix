{ lib, moduleLocation, ... }:
let
  inherit (lib)
    mapAttrs
    mkOption
    types
    ;
  inherit (lib.strings) escapeNixIdentifier;

  # Ported from flake-parts' extras/modules.nix: tag every registered aspect
  # with its class name (`_class`) and registration site (`_file`), wrapping
  # it in a function module so attrset-style aspects are still accepted. The
  # NixOS eval (class "nixos") and home-manager's user eval (class
  # "homeManager") then reject aspects of the wrong class with a clear error.
  addInfo =
    class: moduleName:
    if class == "generic" then
      module: module
    else
      module:
      { ... }:
      {
        _class = class;
        _file = "${toString moduleLocation}#modules.${escapeNixIdentifier class}.${escapeNixIdentifier moduleName}";
        imports = [ module ];
      };
in
{
  options.flake.modules = mkOption {
    type = types.lazyAttrsOf (types.lazyAttrsOf types.deferredModule);
    description = ''
      Aspect registry: `flake.modules.<class>.<name>`.

      The outer attribute is the module class (`nixos` for aspects evaluated
      in the NixOS eval, `homeManager` for home-manager ones). The inner
      attribute is the aspect name; the registry is strictly two levels, so
      roles are flat `nixos` aspects (`graphical`/`headless`/`server`) and
      features are flat `nixos` + `homeManager` aspects. Values are consumed
      by hosts' module lists.
    '';
    apply = mapAttrs (k: mapAttrs (addInfo k));
  };
}
