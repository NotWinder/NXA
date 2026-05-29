{ pkgs
, lib
, config
, ...
}:
let
  inherit (lib) mkIf isx86Linux;

  sys = config.custom.system;
in
{
  config = mkIf sys.video.enable {
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = isx86Linux pkgs;
      };
    };

    # benchmarking tools
    environment.systemPackages = with pkgs; [
      glmark2
    ];
  };
}
