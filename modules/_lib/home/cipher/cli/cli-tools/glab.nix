{ pkgs, ... }: {
  config = {
    home.packages = with pkgs; [
      glab
      glab-tui
    ];
  };
}
