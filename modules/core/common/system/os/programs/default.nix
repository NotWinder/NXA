{
  imports = [
    ./adb.nix
    ./development.nix
    ./lsp.nix
    ./steam.nix
    ./others.nix
    ./thunar.nix
  ];

  programs = {
    # less pager
    less.enable = true;

    # type "fuck" to fix the last command that made you go "fuck"
    thefuck.enable = true;
  };
}
