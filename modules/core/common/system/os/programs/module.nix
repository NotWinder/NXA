{
  imports = [
    ./adb.nix
    ./bash.nix
    ./development.nix
    ./direnv.nix
    ./git.nix
    ./nano.nix
    ./others.nix
    ./thunar.nix
    ./zsh.nix
  ];

  programs = {
    # less pager
    less.enable = true;

    # run commands without installing the programs
    comma.enable = true;
  };
}
