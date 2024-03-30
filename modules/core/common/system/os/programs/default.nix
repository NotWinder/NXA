{ pkgs
, lib
, ...
}: {
  imports = [
    ./development.nix
    ./others.nix
  ];

  programs = {
    # less pager
    less.enable = true;

    # type "fuck" to fix the last command that made you go "fuck"
    thefuck.enable = true;
  };
}
