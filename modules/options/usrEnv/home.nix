{ lib, ... }:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) listOf str;
in
{
  options.custom.usrEnv.home = {
    aspects = mkOption {
      type = listOf str;
      default = [ "base" "cli" "gui" "themes" "misc" ];
      description = ''
        The list of home-manager aspects to compose for the main user.

        Each entry is a name in the `flake.modules.homeManager` aspect
        registry; the `home-manager` wiring module imports them in order.
      '';
    };
  };
}
