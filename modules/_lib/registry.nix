{ lib, ... }:
{
  options.flake.modules = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.lazyAttrsOf lib.types.deferredModule);
    description = ''
      Aspect registry: `flake.modules.<class>.<name>`.

      The outer attribute is the module class (e.g. `nixos`), the inner
      attribute is the aspect name. Values are modules (path, function, or
      module attrset) that will be consumed by later migration phases.
    '';
  };
}
