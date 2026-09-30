{ config
, inputs
, lib
, ...
}:
let
  inherit (lib.modules) mkIf;
in
{
  # DankMaterialShell's NixOS module installs dms + quickshell and its runtime
  # dependencies, and runs dms as a systemd user service bound to
  # graphical-session.target (reached via niri-session; Hyprland starts the
  # unit explicitly, see modules/home/dank-material.nix). Settings stay
  # imperative in ~/.config/DankMaterialShell.
  imports = [
    inputs.dms.nixosModules.dank-material-shell
  ];

  config = mkIf config.custom.programs.dms.enable {
    programs.dank-material-shell = {
      enable = true;
      systemd.enable = true;
    };
  };
}
