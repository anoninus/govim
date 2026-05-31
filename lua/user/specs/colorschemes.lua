-- ===========================
-- Colorschemes (all lazy loaded)
-- ===========================
return {
  {
    'folke/tokyonight.nvim',
    lazy = false,    -- important for colorschemes
    priority = 1000, -- ensure it loads first

    opts = {
      styles = {
        comments  = { italic = false },
        keywords  = { italic = false },
        functions = { italic = false },
        variables = { italic = false },
      },
      sidebars = 'dark',
      floats = 'dark',
    },
  },
}
