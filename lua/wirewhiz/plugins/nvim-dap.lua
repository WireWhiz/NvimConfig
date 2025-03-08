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
    opts = function(_, opts)
        vim.fn.sign_define("DapBreakpoint",
            { text = "", texthl = "DapUIPlayPause", linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointRejected",
            { text = "", texthl = "DapUIBreakpointsDisabledLine", linehl = "", numhl = "" })
        vim.fn.sign_define("DapStopped", { text = "󰛂", texthl = "DapUIPlayPause", linehl = "@comment.todo", numhl = "" })
    end,
    config = function()
        local dap = require("dap")
        local ui = require("dapui")
        ui.setup()

        require("nvim-dap-virtual-text").setup()
        require("mason-nvim-dap").setup({
            ensure_installed = { "codelldb" }
        })

        local dap = require("dap")
        dap.adapters.gdb = {
            type = "executable",
            command = "gdb",
            args = {
                "--interpreter=dap",
                "--eval-command", "set print pretty on",
                "--eval-command", "catch throw",
                "--eval-command", "catch exit"
            }
        }

        dap.adapters.lldb = {
            type = "server",
            port = "${port}",
            executable = {
                command = "lldb-dap",
                args = { "--port", "${port}" },
            }
        }

        local mason_registry = require("mason-registry")
        local codelldb_root = mason_registry.get_package("codelldb"):get_install_path() .. "/extension/"
        local codelldb_path = codelldb_root .. "adapter/codelldb"
        dap.adapters.codelldb = {
            type = "server",
            port = "${port}",
            executable = {
                command = codelldb_path,
                args = { "--port", "${port}" },
            },
        }


        if vim.fn.has("win32") == 1 then
            function log_to_file(path, obj)
                local function dump(o, i)
                    if type(o) == 'table' then
                        local s = ""
                        for t = 0, i do
                            s = s .. "  "
                        end


                        s = s .. '{ \n'
                        for k, v in pairs(o) do
                            if type(k) ~= 'number' then k = '"' .. k .. '"' end

                            for t = 0, i do
                                s = s .. "  "
                            end
                            s = s .. '[' .. k .. '] = ' .. dump(v, i + 1) .. ',\n'
                        end

                        for t = 0, i do
                            s = s .. "  "
                        end
                        return s .. '}\n '
                    else
                        return tostring(o)
                    end
                end
                local sp = dump(obj, 0)
                local file = io.open(path, "w+")
                io.output(file)
                io.write(sp)
                io.close(file)
            end

            local utils = require('dap.utils')

            local rpc = require('dap.rpc')

            local function send_payload(client, payload)
                local msg = rpc.msg_with_content_length(vim.json.encode(payload))
                client.write(msg)
            end

            function RunHandshake(self, request_payload)
                local signResult = io.popen('node %localappdata%\\nvim\\js\\vsdbg-sign.js ' ..
                    request_payload.arguments.value)
                if signResult == nil then
                    log_to_file("payload_msg.txt", 'error while signing handshake')
                    utils.notify('error while signing handshake', vim.log.levels.ERROR)
                    return
                end
                local signature = signResult:read("*a")
                signature = string.gsub(signature, '\n', '')
                local response = {
                    type = "response",
                    seq = 0,
                    command = "handshake",
                    request_seq = request_payload.seq,
                    success = true,
                    body = {
                        signature = signature
                    }
                }
                send_payload(self.client, response)
                log_to_file("payload_msg.txt", response)
            end

            local cpptools_root = os.getenv("USERPROFILE") ..
                "\\.vscode\\extensions\\ms-vscode.cpptools-1.23.6-win32-x64\\"
            local cppdbg_path = cpptools_root .. "debugAdapters\\vsdbg\\bin\\vsdbg.exe"

            dap.adapters.cppvsdbg = {
                type = "executable",
                id = "cppvsdbg",
                command = cppdbg_path,
                args = { "--interpreter=vscode" },
                options = {
                    externalTerminal = true,
                    logging = {
                        moduleLoad = false,
                        trace = true
                    }
                },
                runInTerminal = true,
                reverse_request_handlers = {
                    handshake = RunHandshake,

                },
            }

            dap.listeners.before["initialize"]['validate_cppvsdbg_configs'] = function(session, body)
                if not session.config.type == "cppvsdbg" then
                    return
                end

                local config = session.config
                config.clientID = 'vscode'
                config.clientName = 'vscode'
                config.externalTerminal = true
                config.columnsStartAt1 = true
                config.columnsStartAt1 = true
                config.linesStartAt1 = true
                config.locale = "en"
                config.pathFormat = "path"
                config.externalConsole = true

                session.config = config
                --log_to_file("session_before.txt", session.config)
            end


            -- local cpptools_root = mason_registry.get_package("cpptools"):get_install_path() .. "/extension/"
            -- local cpptools_path = cpptools_root .. "/debugAdapters/bin/OpenDebugAD7.exe"
            --
            -- dap.adapters.cppdbg = {
            --     type = "executable",
            --     name = "cppdbg",
            --     id = "cppdbg",
            --     command = cpptools_path,
            --     options = {
            --         detached = false
            --     },
            -- }
        end

        dap.defaults.fallback.external_terminal = {
            command = 'cmd',
            args = { '-e' },
        }


        dap.listeners.before.attach.dapui_config = function()
            ui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            ui.open()
        end

        vim.keymap.set("n", "<leader>du", function() ui.toggle() end, { desc = "Toggle DAP UI" })

        vim.keymap.set({ "n", "v" }, "<leader>d", "", { desc = "+debug" })
        vim.keymap.set("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
            { desc = "Breakpoint Condition" })
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
        vim.keymap.set("n", "<leader>df", function() dap.focus_frame() end, { desc = "Focus current point of execution" })


        require("overseer").setup()
        vim.keymap.set("n", "<leader>o", "", { desc = "Overseer" })
        vim.keymap.set("n", "<leader>ot", "<cmd>OverseerToggle<CR>", { desc = "Toggle task list" })
        vim.keymap.set("n", "<leader>or", "<cmd>OverseerRun<CR>", { desc = "Select & run a task" })
    end
}
