# {
#   inputs,
#   pkgs,
#   ...
# }:
{
  programs.eww = {
    configDir = ./config;
    enable = true;
    # package = inputs.eww.packages.${pkgs.system}.eww;
  };
}

