-- user/config/ide/file/oil.lua

-- FileType autocmds are cheap, register immediately
vim.api.nvim_create_autocmd('FileType', {
  pattern  = 'oil',
  callback = function()
    vim.opt_local.colorcolumn = ''
    vim.opt_local.tabstop     = 4
    vim.opt_local.shiftwidth  = 4
    vim.opt_local.expandtab   = true
  end,
})

-- Keymap registers immediately, oil loads on first press
vim.keymap.set('n', '-', function()
  require('oil').open()
end, { desc = 'Open parent directory in oil' })

-- Setup deferred until oil is actually needed
vim.api.nvim_create_autocmd({ 'BufEnter', 'User' }, {
  pattern = { '*', 'OilEnter' },
  once    = true,
  callback = function()
    require('oil').setup({
      default_file_explorer = true,
      columns  = { 'icon', 'permissions', 'size', 'mtime' },
      buf_options = { buflisted = false, bufhidden = 'hide' },
      win_options = {
        wrap = true, signcolumn = 'no', cursorcolumn = false,
        foldcolumn = '0', spell = false, list = false,
        conceallevel = 3, concealcursor = 'nvic',
      },
      delete_to_trash              = true,
      skip_confirm_for_simple_edits = false,
      prompt_save_on_select_new_entry = true,
      cleanup_delay_ms             = 2000,
      watch_for_changes            = true,
      use_default_keymaps          = true,
      keymaps = {
        ['g?']   = 'actions.show_help',
        ['<CR>'] = 'actions.select',
        ['<C-s>'] = 'actions.select_vsplit',
        ['<C-h>'] = 'actions.select_split',
        ['<C-t>'] = 'actions.select_tab',
        ['<C-p>'] = 'actions.preview',
        ['<C-c>'] = 'actions.close',
        ['<C-l>'] = 'actions.refresh',
        ['-']    = 'actions.parent',
        ['_']    = 'actions.open_cwd',
        ['`']    = 'actions.cd',
        ['~']    = 'actions.tcd',
        ['gs']   = 'actions.change_sort',
        ['gx']   = 'actions.open_external',
        ['g.']   = 'actions.toggle_hidden',
        ['g\\']  = 'actions.toggle_trash',
      },
      view_options = {
        show_hidden    = true,
        natural_order  = true,
        is_hidden_file = function(name) return vim.startswith(name, '.') end,
        is_always_hidden = function() return false end,
        sort = { { 'type', 'asc' }, { 'name', 'asc' } },
      },
      float    = { padding = 2, max_width = 90, max_height = 30, border = 'rounded', win_options = { winblend = 0 } },
      preview  = { max_width = 0.9, min_width = { 40, 0.4 }, max_height = 0.9, min_height = { 5, 0.1 }, border = 'rounded', win_options = { winblend = 0 }, update_on_cursor_moved = true },
      progress = { max_width = 0.9, min_width = { 40, 0.4 }, max_height = { 10, 0.9 }, min_height = { 5, 0.1 }, border = 'rounded', minimized_border = 'none', win_options = { winblend = 0 } },
      ssh      = { border = 'rounded' },
    })
  end,
})
