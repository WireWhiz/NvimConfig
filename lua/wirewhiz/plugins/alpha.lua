return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        dashboard.section.header.val = {
"██╗    ██╗██╗███████╗    ██╗   ██╗██╗███╗   ███╗",
"██║    ██║██║╚══███╔╝    ██║   ██║██║████╗ ████║",
"██║ █╗ ██║██║  ███╔╝     ██║   ██║██║██╔████╔██║",
"██║███╗██║██║ ███╔╝      ╚██╗ ██╔╝██║██║╚██╔╝██║",
"╚███╔███╔╝██║███████╗     ╚████╔╝ ██║██║ ╚═╝ ██║",
" ╚══╝╚══╝ ╚═╝╚══════╝      ╚═══╝  ╚═╝╚═╝     ╚═╝",
    }
    dashboard.section.header.opts.hl = "String"

    dashboard.section.buttons.val = {
        dashboard.button("󱁐 wr", " > Restore Session", "<cmd>SessionRestore<CR>"),
        dashboard.button("e", " > New file", "<cmd>ene<CR>"),
        dashboard.button("󱁐 ee", " > Open file explorer", "<cmd>NvimTreeToggle<CR>"),
        dashboard.button("󱁐 fr", "󰥌 > Find recent file", "<cmd>Telescope oldfiles<CR>"),
        dashboard.button("󱁐 ff", " > Find file", "<cmd>Telescope find_files<CR>"),
        dashboard.button("q", " Quit", "<cmd>qa<CR>"),
    }

    alpha.setup(dashboard.opts)

    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])

    end,
}
