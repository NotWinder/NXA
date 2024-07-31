{ config, pkgs, ... }:

{
    programs.neovim = {
        enable = true;
        plugins = with pkgs.vimPlugins; [
            undotree
        ];
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
        lua-language-server # lua lsp
        gopls # go lsp
        nil # nix lsp
        rust-analyzer # rust lsp
        nodePackages.typescript-language-server # tsserver lsp
    ];

}
