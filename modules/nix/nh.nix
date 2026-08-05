{ inputs
, config
, lib
, ...
}:
let
  inherit (lib) mkIf;

  sys = config.custom.system;
in
{
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = if sys.nhFlakePath != null then sys.nhFlakePath else inputs.self.outPath;
  };
}
