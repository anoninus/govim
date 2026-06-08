return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = true,
        build = ":TSUpdate",
        event = "VeryLazy",  -- triggers after UI is fully rendered

        config = function()
            -- Defer the entire setup by 50ms after VeryLazy fires
            vim.defer_fn(function()
                require("nvim-treesitter").setup({
                    install_dir = vim.fn.stdpath("data") .. "/site",
                })

                require("nvim-treesitter")
                    .install({
                        "lua", "javascript", "zig", "go",
                        "python", "html", "css",
                    })
                    :wait(300000)

                vim.api.nvim_create_autocmd("FileType", {
                    callback = function()
                        local ok = pcall(vim.treesitter.start)
                        if not ok then return end

                        local wo = vim.wo[0][0]
                        wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                        wo.foldmethod = "expr"
                        wo.foldlevel = 99
                        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end,
                })

                -- Kick treesitter on whatever buffer is already open
                pcall(vim.treesitter.start)

            end, 50) -- 50ms after VeryLazy
        end,
    },
}
