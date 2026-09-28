{ config
, inputs
, pkgs
, lib
, ...
}:
let
  inherit (lib.modules) mkIf;

  # The niri flake requires libdisplay-info_0_2 (v0.2.0) but nixpkgs-unstable
  # only ships libdisplay-info v0.4.0. With config.allowAliases = false, the
  # libdisplay-info_0_2 alias is stripped, so the overlay's callPackage falls
  # back to libdisplay-info (0.4.0) and hits an assertion. Provide it explicitly.
  libdisplay-info-0_2 = pkgs.libdisplay-info.overrideAttrs (old: {
    version = "0.2.0";
    src = pkgs.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "emersion";
      repo = "libdisplay-info";
      rev = "0.2.0";
      hash = "sha256-6xmWBrPHghjok43eIDGeshpUEQTuwWLXNHg7CnBUt3Q=";
    };
  });
in
{
  imports = [
    inputs.niri.nixosModules.niri
  ];
  config = mkIf config.custom.programs.niri.enable {
    nixpkgs.overlays = [
      (final: _prev: { libdisplay-info_0_2 = libdisplay-info-0_2; })
      inputs.niri.overlays.niri
    ];
    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };
  };
}
