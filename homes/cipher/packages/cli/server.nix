{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;

  prg = modules.usrEnv.programs;
  dev = modules.device;
in {
  config = mkIf (prg.cli.enable && (builtins.elem dev.type ["server" "hybrid"])) {
    home.packages = with pkgs; [
      wireguard-tools # Tools for the WireGuard secure network tunnel
    ];
  };
}
