-- ===========================
-- Editor Enhancements
-- ===========================
return {
    {
        'kylechui/nvim-surround',
        keys = { 'ys', 'ds', 'cs', { 'S', mode = 'v' } },
        config = function()
            require('nvim-surround').setup({})
        end,
    },
    {
        'numToStr/Comment.nvim',
        config = function ()
            require('Comment').setup({
                ignore = '^$',
                toggler = {
                    line = 'gcc',
                    block = 'gbc',
                },
            })
        end
    },
}
