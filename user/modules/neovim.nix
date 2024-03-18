{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraLuaConfig = ''

    ${builtins.readFile ./non-nix/nvim/init.lua}

    '';
  };
}
