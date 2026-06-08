return {
    {
        "folke/tokyonight.nvim",
        lazy = true,
        event = "BufReadPre",
        priority = 1000,
        opts = {
            styles = {
                comments = { italic = false },
                keywords = { italic = false },
                functions = { italic = false },
                variables = { italic = false },
            },
        },
        config = function(_, opts)
            require("tokyonight").setup(opts)
            vim.cmd.colorscheme("tokyonight-moon")
        end,
    },
}
