{
  imports = [
    ./adb.nix
    ./development.nix
    ./others.nix
    ./steam.nix
    #./sunshine.nix
    ./thunar.nix
    ./wine.nix
  ];

  programs = {
    # less pager
    less.enable = true;

    # type "fuck" to fix the last command that made you go "fuck"
    thefuck.enable = true;
  };
}
