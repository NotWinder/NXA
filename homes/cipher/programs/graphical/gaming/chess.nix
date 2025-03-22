{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  env = modules.usrEnv;
  prg = env.programs;
in {
  config = mkIf prg.gaming.chess.enable {
    home.packages = with pkgs; [
      kdePackages.knights # Chess board program.
      fairymax # Small chess engine supporting fairy pieces
      stockfish # Strong open source chess engine
      fishnet # Distributed Stockfish analysis for lichess.org
    ];
  };
}
