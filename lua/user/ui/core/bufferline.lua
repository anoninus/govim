-- user/ui/core/bufferline.lua
vim.keymap.set('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<cr>', { silent = true, desc = 'Previous buffer' })
vim.keymap.set('n', '<Tab>', '<cmd>BufferLineCycleNext<cr>', { silent = true, desc = 'Next buffer' })
vim.keymap.set('n', '<A-,>', '<cmd>BufferLineMovePrev<cr>', { silent = true, desc = 'Move buffer left' })
vim.keymap.set('n', '<A-.>', '<cmd>BufferLineMoveNext<cr>', { silent = true, desc = 'Move buffer right' })

require('bufferline').setup({
    options = {
        numbers          = 'ordinal',
        close_command    = 'bdelete! %d',
        indicator        = { style = 'icon' },
        modified_icon    = '●',
        separator_style  = 'thin',
        uniquify_names   = true,
        show_close_icon  = false,
        padding          = 1,
    },
    highlights = {
        buffer_selected  = { bold = true, italic = false },
        numbers_selected = { bold = true, italic = false },
    },
})
