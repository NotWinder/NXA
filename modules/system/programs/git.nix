{ pkgs, ... }: {
  programs.git = {
    enable = true;
    package = pkgs.gitMinimal;
  };
  # Fixes dolphin not having mime types. Copied at build time rather than
  # read during evaluation (IFD), so `nix flake check --no-build` works on a
  # fresh store.
  environment.etc."/xdg/menus/applications.menu".source = pkgs.runCommandLocal "applications.menu" { } ''
    cp ${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu $out
  '';
}
