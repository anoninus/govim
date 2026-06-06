_G.lsp_status = function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
        return ""
    end

    local names = {}
    for _, c in ipairs(clients) do
        table.insert(names, c.name)
    end

    local e = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    local w = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    local h = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    local i = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

    local diag = ""
    if e > 0 then
        diag = diag .. "%#SLDiagError# 󰅚 " .. e .. " %*"
    end
    if w > 0 then
        diag = diag .. "%#SLDiagWarn# 󰀪 " .. w .. " %*"
    end
    if h > 0 then
        diag = diag .. "%#SLDiagHint# 󰌶 " .. h .. " %*"
    end
    if i > 0 then
        diag = diag .. "%#SLDiagInfo#  " .. i .. " %*"
    end

    return "%#SLLSP# 󰒋 " .. table.concat(names, ", ") .. " %*" .. diag
end

_G.sl_filepath = function()
    local path = vim.fn.expand("%:p")
    local bufname = vim.api.nvim_buf_get_name(0)

    -- Handle special buffers (oil://, term://, etc.)
    if bufname:match("^oil://") then
        local dir = bufname:gsub("^oil://", "")
        local home = os.getenv("HOME") or ""
        local prefix = os.getenv("PREFIX") or ""
        dir = dir:gsub("^" .. prefix .. "/tmp", "$PREFIX/tmp")
        dir = dir:gsub("^" .. prefix, "$PREFIX")
        dir = dir:gsub("^" .. home .. "/.config", "󱁿 config")
        dir = dir:gsub("^" .. home .. "/.local/share", "󰉉 data")
        dir = dir:gsub("^" .. home, "~")
        return " 󰉋 " .. dir
    end
    if bufname:match("^term://") then
        return " 󰆍 terminal"
    end
    if path == "" then
        return " 󰈔 [No Name]"
    end

    local home = os.getenv("HOME") or ""
    local prefix = os.getenv("PREFIX") or ""
    local config = os.getenv("XDG_CONFIG_HOME") or (home .. "/.config")
    local data = os.getenv("XDG_DATA_HOME") or (home .. "/.local/share")

    local aliases = {
        { prefix .. "/tmp", "$PREFIX/tmp" },
        { prefix, "$PREFIX" },
        { config, "󱁿 config" },
        { data, "󰉉 data" },
        { home .. "/.config", "󱁿 config" },
        { home .. "/.local/share", "󰉉 data" },
        { home, "~" },
    }

    for _, pair in ipairs(aliases) do
        local dir, label = pair[1], pair[2]
        if dir ~= "" and path:sub(1, #dir) == dir then
            path = label .. path:sub(#dir + 1)
            break
        end
    end

    -- Shorten intermediate dirs to 2 chars instead of 1
    local function shorten_dirs(head, rest)
        local dirs, file = rest:match("^(.*)/([^/]+)$")
        if not dirs or dirs == "" then
            return head .. rest
        end
        local shortened = dirs:gsub("/([^/][^/]?)[^/]*", "/%1")
        return head .. shortened .. "/" .. file
    end

    -- match ~ or $VAR or 󱁿 config style heads
    local head, rest = path:match("^([^/]+)(/.+)$")
    if head and rest then
        path = shorten_dirs(head, rest)
    end

    local ext = vim.fn.expand("%:e")
    local icons = {
        -- Languages
        lua = "󰢱",
        py = "󰌠", -- Python
        js = "󰌞", -- JavaScript
        ts = "󰛦", -- TypeScript
        jsx = "󰌞", -- JSX
        tsx = "󰛦", -- TSX
        rs = "󰌗", -- Rust
        go = "󰟓", -- Go
        c = "󰙱", -- C
        cpp = "󰙲", -- C++
        h = "󰙱", -- Header
        cs = "󰌛", -- C#
        java = "󰬷", -- Java
        rb = "󰬥", -- Ruby
        php = "󰌟", -- PHP
        swift = "󰛥", -- Swift
        kt = "󰌜", -- Kotlin
        scala = "󰌡", -- Scala
        zig = "", -- Zig
        -- Web
        html = "󰌫", -- HTML
        css = "󰌬", -- CSS
        scss = "󰌬", -- SCSS
        json = "󰘦", -- JSON
        yaml = "󰈙", -- YAML
        toml = "󰁭", -- TOML
        xml = "󰗅", -- XML
        -- Shell & Scripts
        sh = "󱆃", -- Shell
        bash = "󱆃", -- Bash
        zsh = "󱆃", -- Zsh
        fish = "󰈺", -- Fish
        ps1 = "󰨊", -- PowerShell
        -- Config & Data
        md = "󰍔", -- Markdown
        txt = "󰈹", -- Text
        csv = "󰇮", -- CSV
        sql = "󰆼", -- SQL
        dockerfile = "󰡨", -- Dockerfile
        makefile = "󰫧", -- Makefile
        -- Editors & VCS
        vim = "", -- Vim
        nix = "󰈕", -- Nix
        git = "󰊢", -- Git
        gitignore = "󰊢", -- Gitignore
        -- Others
        log = "󰋗", -- Log
        lock = "󰌾", -- Lockfile
        license = "󰋼", -- License
        readme = "󰍔", -- README
    }
    local icon = icons[ext] or "󰈔"

    return " " .. icon .. " " .. path
end

local function get_hl(name, attr)
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
    if not ok then
        return nil
    end
    local val = hl[attr]
    if not val then
        return nil
    end
    return string.format("#%06x", val)
end

local function blend(fg, bg, alpha)
    local function parse(c)
        local n = tonumber(c:sub(2), 16)
        local r = math.floor(n / 65536) % 256
        local g = math.floor(n / 256) % 256
        local b = n % 256
        return r, g, b
    end
    local fr, fg_, fb = parse(fg)
    local br, bg_, bb = parse(bg)
    local r = math.floor(fr * alpha + br * (1 - alpha) + 0.5)
    local g = math.floor(fg_ * alpha + bg_ * (1 - alpha) + 0.5)
    local b = math.floor(fb * alpha + bb * (1 - alpha) + 0.5)
    return string.format("#%02x%02x%02x", r, g, b)
end

local function setup_statusline_hls()
    local base_bg = get_hl("Normal", "bg") or "#1e2030"
    local base_fg = get_hl("Normal", "fg") or "#c8d3f5"
    local keyword = get_hl("Function", "fg") or "#82aaff"
    local type_fg = get_hl("Type", "fg") or "#86e1fc"
    local string_ = get_hl("String", "fg") or "#c3e88d"
    local comment = get_hl("Comment", "fg") or "#545c7e"
    local err_fg = get_hl("DiagnosticError", "fg") or "#ff757f"
    local warn_fg = get_hl("DiagnosticWarn", "fg") or "#ffa066"
    local hint_fg = get_hl("DiagnosticHint", "fg") or "#4fd6be"
    local info_fg = get_hl("DiagnosticInfo", "fg") or "#86e1fc"

    local file_bg = blend(keyword, base_bg, 0.20)
    local lsp_bg = blend(string_, base_bg, 0.18)
    local pos_bg = blend(type_fg, base_bg, 0.20)
    local err_bg = blend(err_fg, base_bg, 0.18)
    local warn_bg = blend(warn_fg, base_bg, 0.18)
    local hint_bg = blend(hint_fg, base_bg, 0.18)
    local info_bg = blend(info_fg, base_bg, 0.18)

    -- vim.api.nvim_set_hl(0, "StatusLine", { bg = base_bg, fg = base_fg })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = base_bg, fg = comment })

    vim.api.nvim_set_hl(0, "SLFile", { bg = file_bg, fg = keyword, bold = true })
    vim.api.nvim_set_hl(0, "SLFlags", { bg = file_bg, fg = base_fg })

    vim.api.nvim_set_hl(0, "SLLSP", { bg = lsp_bg, fg = string_, bold = true })

    vim.api.nvim_set_hl(0, "SLDiagError", { bg = err_bg, fg = err_fg, bold = true })
    vim.api.nvim_set_hl(0, "SLDiagWarn", { bg = warn_bg, fg = warn_fg, bold = true })
    vim.api.nvim_set_hl(0, "SLDiagHint", { bg = hint_bg, fg = hint_fg, bold = true })
    vim.api.nvim_set_hl(0, "SLDiagInfo", { bg = info_bg, fg = info_fg, bold = true })

    vim.api.nvim_set_hl(0, "SLPos", { bg = pos_bg, fg = type_fg, bold = true })
    -- vim.api.nvim_set_hl(0, "SLPercent", { bg = base_bg, fg = comment })
end

setup_statusline_hls()

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = setup_statusline_hls,
})

vim.opt.statusline = table.concat({
    "%#SLFile#%{%v:lua.sl_filepath()%} ",
    "%#SLFlags#%m%r",
    "%#StatusLine#%=",
    "%{%v:lua.lsp_status()%}",
    "%#SLPos#  %l,%c ",
    "%#SLPercent# 󰉸 %P ",
})
