-- This file is currently disabled
-- Check if running on Windows
if vim.fn.has("win32") == 1 then
    -- Set PowerShell as the default shell so my build commands can use cross platform terms
    vim.opt.shell = "powershell"
    vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
    vim.opt.shellquote = ""
    vim.opt.shellxquote = ""
end
