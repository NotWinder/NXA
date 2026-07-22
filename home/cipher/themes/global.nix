{ osConfig, ... }:
let
  cfg = osConfig.custom.style;
  inherit (cfg.pointerCursor) package name size;
in
{
  home.pointerCursor = {
    enable = true;

    inherit package name size;

    gtk.enable = true;
    x11.enable = true;
  };
}
