return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "williamboman/mason.nvim",
        "stevearc/overseer.nvim",
        "jay-babu/mason-nvim-dap.nvim",
        "theHamsta/nvim-dap-virtual-text",

    },
    config = function()
        local dap = require("dap")
        local ui = require("dapui")
        ui.setup()

        require("nvim-dap-virtual-text").setup()
        require("mason-nvim-dap").setup({
            ensure_installed = { "codelldb" }
        })

        local mason_registry = require("mason-registry")
        local codelldb_root = mason_registry.get_package("codelldb"):get_install_path() .. "/extension/"
        local codelldb_path = codelldb_root .. "adapter/codelldb"
        dap.adapters.codelldb = {
            type ="server",
            port = "${port}",
            executable = {
                command = codelldb_path,
                args = { "--port", "${port}" },
            },
        }

        dap.listeners.before.attach.dapui_config = function()
            ui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            ui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            ui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            ui.close()
        end

        vim.keymap.set("n", "<leader>du", function() ui.toggle() end, { desc = "Toggle DAP UI"})

        vim.keymap.set({"n", "v"}, "<leader>d", "", { desc = "+debug" })
        vim.keymap.set("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { desc = "Breakpoint Condition" })
        vim.keymap.set("n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
        vim.keymap.set("n", "<leader>dc", function() dap.continue() end, { desc = "Continue" })
        vim.keymap.set("n", "<leader>da", function() dap.continue({ before = get_args }) end, { desc = "Run with Args" })
        vim.keymap.set("n", "<leader>dC", function() dap.run_to_cursor() end, { desc = "Run to Cursor" })
        vim.keymap.set("n", "<leader>dg", function() dap.goto_() end, { desc = "Go to Line (No Execute)" })
        vim.keymap.set("n", "<leader>di", function() dap.step_into() end, { desc = "Step Into" })
        vim.keymap.set("n", "<leader>dj", function() dap.down() end, { desc = "Down" })
        vim.keymap.set("n", "<leader>dk", function() dap.up() end, { desc = "Up" })
        vim.keymap.set("n", "<leader>dl", function() dap.run_last() end, { desc = "Run Last" })
        vim.keymap.set("n", "<leader>do", function() dap.step_out() end, { desc = "Step Out" })
        vim.keymap.set("n", "<leader>dO", function() dap.step_over() end, { desc = "Step Over" })
        vim.keymap.set("n", "<leader>dp", function() dap.pause() end, { desc = "Pause" })
        vim.keymap.set("n", "<leader>dr", function() dap.repl.toggle() end, { desc = "Toggle REPL" })
        vim.keymap.set("n", "<leader>ds", function() dap.session() end, { desc = "Session" })
        vim.keymap.set("n", "<leader>dt", function() dap.terminate() end, { desc = "Terminate" })
        vim.keymap.set("n", "<leader>dw", function() require("dap.ui.widgets").hover() end, { desc = "Widgets" })

        require("overseer").setup()
        vim.keymap.set("n", "<leader>o", "", { desc = "Overseer" })
        vim.keymap.set("n", "<leader>ot", "<cmd>OverseerToggle<CR>", {desc= "Toggle task list" })
        vim.keymap.set("n", "<leader>or", "<cmd>OverseerRun<CR>", {desc= "Select & run a task" })


    end
}
