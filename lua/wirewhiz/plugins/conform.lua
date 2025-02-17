return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require("conform")


        conform.setup({
            formaters_by_ft = {
                cpp = {"clang-format"},
                c = {"clang-format"},
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                svelte = { "prettier" },
                css = { "prettier" },
                html = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                graphql = { "prettier" },
                lua = { "stylua" },
                python = { "isort", "black" },
            },
            format_on_save = function(buf_id)
                if not vim.g.disable_format_on_save then
                    return {
                        lsp_fallback = true,
                        async = false,
                        timeout_ms = 1500
                    }
                end
            end
        })

        vim.keymap.set({"n", "v"}, "<leader>cf", function() vim.g.disable_format_on_save = not vim.g.disable_format_on_save end, {desc = "Toggle format on save"})
        vim.keymap.set({"n", "v"}, "<leader>rf", function() conform.format({
            lsp_fallback = true,
            async = false,
            timeout_ms = 1500
        }) end, {desc = "Format file or selection"})
    end
}

