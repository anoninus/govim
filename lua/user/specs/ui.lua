return {
    {
        'akinsho/bufferline.nvim',
        version = '*',
        event = 'VeryLazy',
        dependencies = { 'echasnovski/mini.icons', version = false },
        config = function() require('user.ui.core.bufferline') end,
    },
    {
        'stevearc/dressing.nvim',
        event = "VeryLazy",
        opts = {
            input = {
                enabled        = true,
                default_prompt = 'Input',
                trim_prompt    = true,
                title_pos      = 'left',
                start_mode     = 'insert',
                border         = 'rounded',
                relative       = 'cursor',
                prefer_width   = 40,
                max_width      = { 140, 0.9 },
                min_width      = { 20, 0.2 },
                win_options    = {
                    wrap          = true,
                    list          = true,
                    listchars     = 'precedes:…,extends:…',
                    sidescrolloff = 0,
                },
                mappings       = {
                    n = { ['<Esc>'] = 'Close', ['<CR>'] = 'Confirm' },
                    i = { ['<C-c>'] = 'Close', ['<CR>'] = 'Confirm', ['<Up>'] = 'HistoryPrev', ['<Down>'] = 'HistoryNext' },
                },
            },
            select = {
                enabled     = true,
                backend     = { 'fzf_lua', 'fzf', 'builtin' }, -- telescope removed
                trim_prompt = true,
                fzf_lua     = {},
                builtin     = {
                    show_numbers = true,
                    border       = 'rounded',
                    relative     = 'editor',
                    win_options  = {
                        cursorline    = true,
                        cursorlineopt = 'both',
                        winhighlight  = 'MatchParen:',
                        statuscolumn  = ' ',
                    },
                    max_width    = { 140, 0.8 },
                    min_width    = { 40, 0.2 },
                    max_height   = 0.9,
                    min_height   = { 10, 0.2 },
                    mappings     = { ['<Esc>'] = 'Close', ['<C-c>'] = 'Close', ['<CR>'] = 'Confirm' },
                },
            },
        },

    },
    {
        'beauwilliams/focus.nvim',
        --         commit = '4135f97',
        cmd = { 'FocusSplitNicely', 'FocusSplitCycle', 'FocusToggle' },
    },

    -- in user/specs/ui.lua or wherever your UI plugins live
    {
        'lukas-reineke/indent-blankline.nvim',
        main   = 'ibl',
        lazy   = true,
        config = function()
            require('ibl').setup({
                indent = {
                    char = '│', -- or '▏' for thinner, '┊' for dotted
                    tab_char = '│',
                    highlight = { 'IblIndent' },
                    smart_indent_cap = true,
                },

                whitespace = {
                    remove_blankline_trail = true,
                },

                scope = {
                    enabled = false, -- Let mini.indentscope handle this
                },

                exclude = {
                    filetypes = {
                        'help', 'dashboard', 'neo-tree', 'Trouble', 'trouble',
                        'lazy', 'mason', 'notify', 'toggleterm', 'lazyterm',
                        'packer', 'checkhealth', 'man', 'gitcommit',
                        'TelescopePrompt', 'TelescopeResults', 'lspinfo',
                        'alpha', 'starter', '',
                    },
                    buftypes = {
                        'terminal', 'nofile', 'quickfix', 'prompt',
                    },
                },
            })
        end
    },
}
