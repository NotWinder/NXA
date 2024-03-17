{
  programs.git = {
    enable = true;
    userName = "winder2412";
    userEmail = "winderdawshmaster@gmail.com";
    extraConfig = {
      credential = {
        "https://github.com" = {
          helper = "!gh auth git-credential";
        };
        "https://gist.github.com" = {
          helper = "!gh auth git-credential";
        };
      };
    };
  };
  programs.gh = {
    gitCredentialHelper.enable = false;
  };
}
