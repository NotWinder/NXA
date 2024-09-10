{ config, pkgs, inputs, ... }:

{
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      undotree
      telescope-nvim
      telescope-ui-select-nvim
      none-ls-nvim
      onedark-nvim
      lualine-nvim
      harpoon
      mason-nvim
      mason-lspconfig-nvim
      nvim-lspconfig
      cmp-nvim-lsp
      luasnip
      cmp_luasnip
      friendly-snippets
      nvim-cmp
      nvim-treesitter
    ];
    extraLuaConfig = "require('winder')";
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
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
    nodePackages.typescript-language-server # tsserver lsp
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
