{ config, pkgs, inputs, ... }:

{
  programs.neovim = {
    enable = true;
    extraLuaConfig = "require('winder')";
    plugins = with pkgs.vimPlugins; [
      #plugins
      cmp-nvim-lsp
      cmp_luasnip
      friendly-snippets
      harpoon
      lualine-nvim
      luasnip
      mason-lspconfig-nvim
      mason-nvim
      none-ls-nvim
      nvim-cmp
      nvim-lspconfig
      nvim-treesitter
      onedark-nvim
      telescope-nvim
      telescope-ui-select-nvim
      undotree
    ];
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
  };
  programs.ripgrep.enable = true;

  home.file."${config.xdg.configHome}/nvim" = {
    source = ./nvim;
    recursive = true;
  };

  home.packages = with pkgs;[
    #lsps
    lua-language-server # lua lsp
    gopls # go lsp
    #nil # nix lsp
    inputs.nil_ls.packages.${system}.default
    rust-analyzer # rust lsp
    typescript-language-server # ts_ls
    #formatters and linters
    black
    golines
    isort
    nixpkgs-fmt
    nodePackages.prettier
    revive
    stylua
  ];

}
