-- user/config/ide/file/fzf.lua

-- Highlights are cheap, keep these at top level
vim.api.nvim_set_hl(0, 'FzfLuaNormal',        { link = 'Normal' })
vim.api.nvim_set_hl(0, 'FzfLuaBorder',        { link = 'FloatBorder' })
vim.api.nvim_set_hl(0, 'FzfLuaTitle',         { link = 'Title' })
vim.api.nvim_set_hl(0, 'FzfLuaPreviewNormal', { link = 'Normal' })
vim.api.nvim_set_hl(0, 'FzfLuaCursorLine',    { link = 'Visual' })
vim.api.nvim_set_hl(0, 'FzfLuaCursor',        { link = 'IncSearch' })

-- Setup runs on first keypress, not at startup
local setup_done = false
local function fzf()
  if not setup_done then
    setup_done = true
    require('fzf-lua').setup({
      winopts = {
        height = 0.85, width = 0.80, row = 0.35, col = 0.50,
        border  = 'rounded',
        preview = {
          border = 'rounded', wrap = 'nowrap', hidden = 'nohidden',
          vertical = 'down:45%', horizontal = 'right:60%',
          layout = 'flex', flip_columns = 120,
        },
      },
      fzf_colors = {
        ['fg']      = { 'fg', 'Normal' },     ['bg']      = { 'bg', 'Normal' },
        ['fg+']     = { 'fg', 'Normal' },     ['bg+']     = { 'bg', 'Visual' },
        ['hl']      = { 'fg', 'Identifier' }, ['hl+']     = { 'fg', 'Statement' },
        ['prompt']  = { 'fg', 'Keyword' },    ['pointer'] = { 'fg', 'Type' },
        ['marker']  = { 'fg', 'Type' },       ['header']  = { 'fg', 'Title' },
        ['info']    = { 'fg', 'Special' },
      },
      files = {
        prompt = ' ', multiprocess = true,
        git_icons = true, file_icons = true, color_icons = true,
        fd_opts = '--color=never --type f --hidden --follow --exclude .git',
      },
      grep = {
        prompt = ' ', input_prompt = 'Grep  ', multiprocess = true,
        git_icons = true, file_icons = true, color_icons = true,
        rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case -g '!.git'",
      },
    })
  end
  return require('fzf-lua')
end

-- Termux detection (computed once, not per keypress)
local _home, _root
local function sys_home()
  if _home then return _home end
  _home = vim.env.TERMUX_VERSION and '/data/data/com.termux/files/home' or vim.env.HOME or vim.fn.getcwd()
  return _home
end
local function sys_root()
  if _root then return _root end
  _root = vim.env.TERMUX_VERSION and '/data/data/com.termux/files' or '/'
  return _root
end

-- Keymaps — all lazy, setup fires on first use
local k = vim.keymap.set
k('n', '<leader>fz',  function() fzf().setup_called = true; vim.cmd('FzfLua') end,                          { desc = 'FzfLua' })
k('n', '<leader>fb',  function() fzf().buffers() end,                                                        { desc = 'Buffers' })
k('n', '<leader>fd',  function() fzf().files() end,                                                          { desc = 'Find files CWD' })
k('n', '<leader>fo',  function() fzf().oldfiles() end,                                                       { desc = 'Recent files' })
k('n', '<leader>fgc', function() fzf().live_grep() end,                                                      { desc = 'Live grep CWD' })
k('n', '<leader>ft',  function() fzf().diagnostics_workspace() end,                                          { desc = 'Workspace diagnostics' })
k('n', '<leader>fc',  function() fzf().live_grep({ cwd = vim.fn.stdpath('config'), prompt = '< Config Grep > ' }) end, { desc = 'Grep config' })
k('n', '<leader>tc',  function() fzf().files({ cwd = vim.fn.expand('$MYVIMRC'):match('(.*/)'), prompt = '< Neovim Config > ' }) end, { desc = 'Find config files' })
k('n', '<leader>fs',  function() fzf().files({ cwd = vim.fn.stdpath('config') .. '/lua/user/stages', prompt = '< User Stages > ' }) end, { desc = 'Find stage files' })
k('n', '<leader>fih', function() fzf().files({ cwd = sys_home() }) end,                                      { desc = 'Find files home' })
k('n', '<leader>fir', function() fzf().files({ cwd = sys_root() }) end,                                      { desc = 'Find files root' })
k('n', '<leader>fgh', function() fzf().live_grep({ cwd = sys_home() }) end,                                  { desc = 'Grep home' })
k('n', '<leader>fgr', function() fzf().live_grep({ cwd = sys_root() }) end,                                  { desc = 'Grep root' })
k('n', '<leader>gc',  function() fzf().git_commits() end,                                                    { desc = 'Git commits' })
k('n', '<leader>gs',  function() fzf().git_status() end,                                                     { desc = 'Git status' })
k('n', '<leader>fgi', function()
  vim.notify(string.format('Environment: %s\nHome: %s\nRoot: %s',
    vim.env.TERMUX_VERSION and 'Termux' or 'Standard Linux', sys_home(), sys_root()),
    vim.log.levels.INFO)
end, { desc = 'System info' })
