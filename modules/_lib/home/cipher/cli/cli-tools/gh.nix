{ pkgs, ... }: {
  config = {
    home.packages = with pkgs; [
      gh
      gh-dash
      gh-eco
      gh-cal
      gh-poi
    ];
  };
}
