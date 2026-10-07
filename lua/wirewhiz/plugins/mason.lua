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
                "expert"
            },
            -- ltex runs a JVM that grammar-checks every markdown buffer, and ltex_plus
            -- crash-loops on this Java version. Both ate RAM and spammed lsp.log.
            automatic_enable = { exclude = { "ltex", "ltex_plus" } },
        })
    end
}
