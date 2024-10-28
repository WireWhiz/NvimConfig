return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
        "windwp/nvim-ts-autotag",
    },
    config = function()
        local treesitter = require("nvim-treesitter.configs")

        treesitter.setup({
            highlight = {
                enable = true,
            },
            indent = { enable = true },

            autotag = {
                example = true,
            },

            ensure_installed = {
                "c",
                "c_sharp",
                "cpp",
                "rust",
                "cmake",
                "make",
                "diff",
                "arduino",
                "asm",
                "nasm",
                "bash",
                "disassembly",
                "powershell",
                "json",
                "toml",
                "yaml",
                "gitignore",
                "html",
                "css",
                "javascript",
                "tsx",
                "typescript",
                "python",
                "printf",
                "glsl",
                "hlsl",
                "llvm",
                "lua",
                "vim",
                "vimdoc",
                "regex",
                "sql",
                "zig"
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
        })
    end,
}
