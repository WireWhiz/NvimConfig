return {
    'anuvyklack/hydra.nvim',
    requires = 'anuvyklack/keymap-layer.nvim',
    config = function()
        local Hydra = require('hydra')

        -- Resize splits
        Hydra({
          name = 'Resize Split',
          mode = 'n',  -- normal mode
          body = '<leader>sr',  -- start the Hydra with <leader>w
          heads = {
            { 'h', function()
                vim.cmd('execute "normal! \\<C-w><"')
              end, { hint = "Shrink horizontally" }
            },
            { 'j', function()
                vim.cmd('execute "normal! \\<C-w>-"')
              end, { hint = "Shrink vertically"}
            },
            { 'k', function()
                vim.cmd('execute "normal! \\<C-w>+"')
              end, { hint = "Expand vertically" }
            },
            { 'l', function()
                vim.cmd('execute "normal! \\<C-w>>"')
              end, { hint = "Expand horizontally" }
            },
            { '<Esc>', nil, { exit = true } } -- escape to exit
          }
        })
    end,
    keys = {
        {"<leader>sr", desc = "Resize split using hjkl" },
    }
}

