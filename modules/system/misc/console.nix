{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) attrValues mkDefault;
in {
  console = let
    variant = "v18n";
  in {
    enable = mkDefault true;
    earlySetup = true;

    font = "ter-powerline-${variant}";
    packages = attrValues {inherit (pkgs) terminus_font powerline-fonts;};
  };

  # FIXME: kmscon, in my testing, is working as advertised and a performance difference
  # is observable. However, enabling kmscon seems to *completely* ignore silent boot
  # parameters. Not sure if this is a potential conflict with earlySetup (probably not)
  # or kmscon not respecting the kernel parameters (more likely). Either way, I will
  # revisit this in the future.
  services.kmscon = {
    enable = false;
    config.hwaccel = true;

    extraOptions = "--term xterm-256color";
    config = {
      "font-size" = 14;
      "font-name" = "Source Code Pro";
    };
  };
}
