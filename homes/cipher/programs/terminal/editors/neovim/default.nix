{inputs', ...}: {
  home.packages = [
    inputs'.nvw.packages.default
  ];

  programs.ripgrep.enable = true;
}
