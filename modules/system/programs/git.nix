{pkgs, ...}: {
  programs.git = {
    enable = true;
    package = pkgs.gitMinimal;
  };
  # Fixes dolphin not having mime types.
  environment.etc."/xdg/menus/applications.menu".text = builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
}
