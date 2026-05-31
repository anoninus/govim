-- ===========================
-- Formatting & Diagnostics
-- ===========================
return {
    {
        'stevearc/conform.nvim',
        event = "BufWritePre",
        config = function()
            require("user.config.tools.formatter")
        end
    },
}
