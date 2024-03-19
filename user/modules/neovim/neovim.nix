{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
   extraLuaConfig = ''

   ${builtins.readFile ./nvim/init.lua}

   '';
  };
}
