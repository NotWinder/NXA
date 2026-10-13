{ pkgs
, lib
, ...
}:
let
  inherit (lib) attrValues mkDefault;
in
{
  console =
    let
      variant = "v18n";
    in
    {
      enable = mkDefault true;
      earlySetup = true;

      font = "ter-powerline-${variant}";
      packages = attrValues { inherit (pkgs) terminus_font powerline-fonts; };
    };

  # kmscon is disabled on purpose: it works and is faster, but it ignores the
  # silent boot kernel parameters (likely kmscon itself rather than
  # earlySetup).
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
