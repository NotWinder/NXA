return {
    {
        "williamboman/mason.nvim",
        lazy = false;
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "gopls" , "tsserver" },
            })
            require("mason-lspconfig").setup_handlers ({
                function (server_name)
                    require("lspconfig")[server_name].setup ({ capabilities = capabilities })
                end,
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local augroup = vim.api.nvim_create_augroup
            local WinderGroup = augroup("winder", {})
            local autocmd = vim.api.nvim_create_autocmd
            local yank_group = augroup('HighlightYank', {})

            autocmd("LspAttach", {
                group = WinderGroup,
                callback = function(e)
                    local opts = { buffer = e.buf }
                    vim.keymap.set("n", "gd", function()
                        vim.lsp.buf.definition()
                    end, opts)
                    vim.keymap.set("n", "K", function()
                    vim.lsp.buf.hover()
                    end, opts)
                    vim.keymap.set("n", "<leader>vws", function()
                        vim.lsp.buf.workspace_symbol()
                    end, opts)
                    vim.keymap.set("n", "<leader>vd", function()
                        vim.diagnostic.open_float()
                    end, opts)
                    vim.keymap.set("n", "<leader>vca", function()
                        vim.lsp.buf.code_action()
                    end, opts)
                    vim.keymap.set("n", "<leader>vrr", function()
                        vim.lsp.buf.references()
                    end, opts)
                    vim.keymap.set("n", "<leader>vrn", function()
                        vim.lsp.buf.rename()
                    end, opts)
                    vim.keymap.set("i", "<C-h>", function()
                        vim.lsp.buf.signature_help()
                    end, opts)
                    vim.keymap.set("n", "[d", function()
                        vim.diagnostic.goto_next()
                    end, opts)
                    vim.keymap.set("n", "]d", function()
                        vim.diagnostic.goto_prev()
                    end, opts)
                end,
            })
        end,
    },
}
