-- ============================================================
-- Dynamic UI Enhancer - Sticker backgrounds for ALL plugins
-- ============================================================

local M = {}

function M.setup()
  local function set_ui_highlights()
    -- Helper: safely pull a highlight group's attributes
    local function hl(group)
      return vim.api.nvim_get_hl(0, { name = group, link = false })
    end

    -- Helper: convert decimal color to hex string
    local function to_hex(dec)
      if not dec then return nil end
      return string.format('#%06x', dec)
    end

    -- Get theme colors
    local float_bg_group = hl('NormalFloat')
    local float_bg = float_bg_group.bg and to_hex(float_bg_group.bg)
    
    if not float_bg then
      local normal_bg = hl('Normal').bg
      float_bg = normal_bg and to_hex(normal_bg)
    end
    
    -- Get accent color for sticker background
    local accent_sources = {
      'Special', 'Function', 'Keyword', 'Statement', 'Type', 'Constant'
    }
    
    local accent_color = nil
    for _, group in ipairs(accent_sources) do
      local h = hl(group)
      if h.fg then
        accent_color = to_hex(h.fg)
        break
      end
    end
    
    -- Get contrasting text color for sticker
    local function get_contrast_color(hex)
      if not hex then return nil end
      local r = tonumber(hex:sub(2,3), 16)
      local g = tonumber(hex:sub(4,5), 16)
      local b = tonumber(hex:sub(6,7), 16)
      local luminance = (0.299 * r + 0.587 * g + 0.114 * b)
      return luminance > 128 and '#000000' or '#ffffff'
    end
    
    local sticker_bg = accent_color
    local sticker_fg = sticker_bg and get_contrast_color(sticker_bg) or nil
    
    -- Fallbacks
    if not accent_color then
      local normal_bg = hl('Normal').bg
      if normal_bg then
        local r = 255 - bit.band(bit.rshift(normal_bg, 16), 0xFF)
        local g = 255 - bit.band(bit.rshift(normal_bg, 8), 0xFF)
        local b = 255 - bit.band(normal_bg, 0xFF)
        accent_color = string.format('#%02x%02x%02x', r, g, b)
        sticker_fg = get_contrast_color(accent_color)
      else
        accent_color = vim.o.background == 'dark' and '#ffffff' or '#000000'
        sticker_fg = vim.o.background == 'dark' and '#000000' or '#ffffff'
      end
    end

    -- -------------------------------------------------------
    -- Core UI
    -- -------------------------------------------------------
    vim.api.nvim_set_hl(0, 'FloatBorder', { fg = accent_color, bg = float_bg, bold = true })
    vim.api.nvim_set_hl(0, 'WinSeparator', { fg = accent_color, bold = true })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = float_bg })
    vim.api.nvim_set_hl(0, 'FloatTitle', { fg = sticker_fg, bg = sticker_bg, bold = true })

    -- -------------------------------------------------------
    -- fzf-lua - Sticker background for titles
    -- -------------------------------------------------------
    vim.api.nvim_set_hl(0, 'FzfLuaBorder', { fg = accent_color, bg = float_bg, bold = true })
    vim.api.nvim_set_hl(0, 'FzfLuaTitle', { fg = sticker_fg, bg = sticker_bg, bold = true })
    vim.api.nvim_set_hl(0, 'FzfLuaNormal', { bg = float_bg })
    vim.api.nvim_set_hl(0, 'FzfLuaHeaderTitle', { fg = sticker_fg, bg = sticker_bg, bold = true })

    -- -------------------------------------------------------
    -- which-key.nvim - Sticker for title
    -- -------------------------------------------------------
    vim.api.nvim_set_hl(0, 'WhichKeyBorder', { fg = accent_color, bg = float_bg, bold = true })
    vim.api.nvim_set_hl(0, 'WhichKeyTitle', { fg = sticker_fg, bg = sticker_bg, bold = true })
    vim.api.nvim_set_hl(0, 'WhichKeyFloat', { bg = float_bg })

    -- -------------------------------------------------------
    -- telescope.nvim - Sticker for all titles
    -- -------------------------------------------------------
    vim.api.nvim_set_hl(0, 'TelescopeBorder', { fg = accent_color, bg = float_bg, bold = true })
    vim.api.nvim_set_hl(0, 'TelescopeTitle', { fg = sticker_fg, bg = sticker_bg, bold = true })
    vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = float_bg })
    vim.api.nvim_set_hl(0, 'TelescopeResultsTitle', { fg = sticker_fg, bg = sticker_bg, bold = true })
    vim.api.nvim_set_hl(0, 'TelescopePreviewTitle', { fg = sticker_fg, bg = sticker_bg, bold = true })
    vim.api.nvim_set_hl(0, 'TelescopePromptTitle', { fg = sticker_fg, bg = sticker_bg, bold = true })

    -- -------------------------------------------------------
    -- dressing.nvim - Input dialog sticker
    -- -------------------------------------------------------
    vim.api.nvim_set_hl(0, 'DressingBorder', { fg = accent_color, bg = float_bg, bold = true })
    vim.api.nvim_set_hl(0, 'DressingTitle', { fg = sticker_fg, bg = sticker_bg, bold = true })
    vim.api.nvim_set_hl(0, 'DressingNormal', { bg = float_bg })

    -- -------------------------------------------------------
    -- trouble.nvim - Sticker for diagnostics
    -- -------------------------------------------------------
    vim.api.nvim_set_hl(0, 'TroubleBorder', { fg = accent_color, bg = float_bg, bold = true })
    vim.api.nvim_set_hl(0, 'TroubleTitle', { fg = sticker_fg, bg = sticker_bg, bold = true })
    vim.api.nvim_set_hl(0, 'TroubleNormal', { bg = float_bg })

    -- -------------------------------------------------------
    -- lazy.nvim - Plugin manager sticker
    -- -------------------------------------------------------
    vim.api.nvim_set_hl(0, 'LazyBorder', { fg = accent_color, bg = float_bg, bold = true })
    vim.api.nvim_set_hl(0, 'LazyTitle', { fg = sticker_fg, bg = sticker_bg, bold = true })
    vim.api.nvim_set_hl(0, 'LazyNormal', { bg = float_bg })
    vim.api.nvim_set_hl(0, 'LazyHeader', { fg = sticker_fg, bg = sticker_bg, bold = true })

    -- -------------------------------------------------------
    -- mini.notify / nvim-notify - Notification sticker
    -- -------------------------------------------------------
    vim.api.nvim_set_hl(0, 'NotifyINFOBorder', { fg = accent_color, bg = float_bg, bold = true })
    vim.api.nvim_set_hl(0, 'NotifyINFOTitle', { fg = sticker_fg, bg = sticker_bg, bold = true })
    vim.api.nvim_set_hl(0, 'NotifyBackground', { bg = float_bg })
    
    -- Different notification levels with colored stickers
    local error_color = to_hex(hl('DiagnosticError').fg) or '#f4466b'
    local warn_color = to_hex(hl('DiagnosticWarn').fg) or '#ffb86c'
    
    vim.api.nvim_set_hl(0, 'NotifyERRORTitle', { fg = get_contrast_color(error_color), bg = error_color, bold = true })
    vim.api.nvim_set_hl(0, 'NotifyWARNTitle', { fg = get_contrast_color(warn_color), bg = warn_color, bold = true })

    -- -------------------------------------------------------
    -- nui.nvim - Sticker support
    -- -------------------------------------------------------
    vim.api.nvim_set_hl(0, 'NuiBorder', { fg = accent_color, bg = float_bg, bold = true })
    vim.api.nvim_set_hl(0, 'NuiTitle', { fg = sticker_fg, bg = sticker_bg, bold = true })
    vim.api.nvim_set_hl(0, 'NuiNormal', { bg = float_bg })

    -- -------------------------------------------------------
    -- mason.nvim - LSP installer sticker
    -- -------------------------------------------------------
    vim.api.nvim_set_hl(0, 'MasonBorder', { fg = accent_color, bg = float_bg, bold = true })
    vim.api.nvim_set_hl(0, 'MasonTitle', { fg = sticker_fg, bg = sticker_bg, bold = true })
    vim.api.nvim_set_hl(0, 'MasonNormal', { bg = float_bg })

    -- -------------------------------------------------------
    -- noice.nvim (if used) - Sticker for cmdline popup
    -- -------------------------------------------------------
    vim.api.nvim_set_hl(0, 'NoiceBorder', { fg = accent_color, bg = float_bg, bold = true })
    vim.api.nvim_set_hl(0, 'NoiceTitle', { fg = sticker_fg, bg = sticker_bg, bold = true })
    vim.api.nvim_set_hl(0, 'NoicePopupNormal', { bg = float_bg })

    -- -------------------------------------------------------
    -- illuminate.nvim / references - Keep minimal
    -- -------------------------------------------------------
    -- Not touching these - they work fine as-is
  end

  -- Apply on startup
  set_ui_highlights()

  -- Re-apply after colorscheme changes
  vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    callback = set_ui_highlights,
    desc = 'Update all plugin borders and stickers from theme',
  })
end

return M
