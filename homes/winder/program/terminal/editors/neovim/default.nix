{ inputs, ... }:
let
  system = "x86_64-linux";
in

{
  programs.neovim = inputs.nvw.lib.mkHomeManager { inherit system; };
  #programs.neovim = {
  #  enable = true;
  #  extraLuaConfig = "require('winder')";
  #  plugins = with pkgs.vimPlugins; [
  #    #LSP
  #    mason-nvim
  #    mason-lspconfig-nvim
  #    nvim-lspconfig

  #    #CMP
  #    nvim-cmp
  #    luasnip
  #    cmp_luasnip
  #    friendly-snippets
  #    cmp-nvim-lsp

  #    harpoon
  #    lualine-nvim
  #    none-ls-nvim
  #    nvim-treesitter
  #    onedark-nvim
  #    telescope-nvim
  #    telescope-ui-select-nvim
  #    undotree
  #  ];
  #  viAlias = true;
  #  vimAlias = true;
  #  vimdiffAlias = true;
  #  withNodeJs = true;
  #  withPython3 = true;
  #  withRuby = true;
  #};
  #programs.ripgrep.enable = true;

  #home.file."${config.xdg.configHome}/nvim" = {
  #  source = ./nvim;
  #  recursive = true;
  #};

  #home.packages = with pkgs;[
  #  #lsps
  #  lua-language-server # lua lsp
  #  gopls # go lsp
  #  #nixd # nix lsp
  #  nixd
  #  rust-analyzer # rust lsp
  #  typescript-language-server # ts_ls
  #  #formatters and linters
  #  black
  #  golines
  #  isort
  #  nixpkgs-fmt
  #  nodePackages.prettier
  #  revive
  #  stylua
  #];

}
