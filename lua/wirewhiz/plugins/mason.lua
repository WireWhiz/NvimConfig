return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        local mason = require("mason")

        local mason_lspconfig = require("mason-lspconfig")

        mason.setup({

        })

        mason_lspconfig.setup({
            ensure_installed = {
                "arduino_language_server",
                "bashls",
                "csharp_ls",
                "clangd",
                "tailwindcss",
                "gradle_ls",
                "html",
                "eslint",
                "jsonls",
                "lua_ls",
                "markdown_oxide",
                "powershell_es",
                "pylyzer",
                "rust_analyzer",
                "sqlls",
                "vimls",
                "yamlls",
                "zls",
                "ltex",
                "ltex_plus",
                "expert"
            },
        })
    end
}
