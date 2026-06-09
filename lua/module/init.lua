-- lua/module/init.lua
require("module.autosave.config")
-- require("module.run.config")

vim.keymap.set("n", "<F1>",  function() require("module.terminal.config") end)
vim.keymap.set("n", "<F12>", function() require("module.terminal.config") end)
