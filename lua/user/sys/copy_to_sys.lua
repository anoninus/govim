-- Smart Clipboard System - Fixed and Simple
-- No async delays, works with Termux, uses telescope for pickers

-- ============================================================================
-- SMART CLIPBOARD DETECTION
-- ============================================================================
local function detect_clipboard()
    local systems = {
        {
            name = 'Termux',
            check = function()
                return vim.fn.executable('termux-clipboard-set') == 1
            end,
            copy_cmd = 'termux-clipboard-set',
            paste_cmd = 'termux-clipboard-get',
        },
        {
            name = 'Wayland',
            check = function()
                return vim.fn.executable('wl-copy') == 1
            end,
            copy_cmd = 'wl-copy',
            paste_cmd = 'wl-paste',
        },
        {
            name = 'X11 (xclip)',
            check = function()
                return vim.fn.executable('xclip') == 1
            end,
            copy_cmd = 'xclip -selection clipboard',
            paste_cmd = 'xclip -selection clipboard -o',
        },
        {
            name = 'X11 (xsel)',
            check = function()
                return vim.fn.executable('xsel') == 1
            end,
            copy_cmd = 'xsel --clipboard --input',
            paste_cmd = 'xsel --clipboard --output',
        },
        {
            name = 'macOS',
            check = function()
                return vim.fn.executable('pbcopy') == 1
            end,
            copy_cmd = 'pbcopy',
            paste_cmd = 'pbpaste',
        },
        {
            name = 'Windows/WSL',
            check = function()
                return vim.fn.executable('clip.exe') == 1
            end,
            copy_cmd = 'clip.exe',
            paste_cmd = 'powershell.exe -c Get-Clipboard',
        },
    }
    
    for _, sys in ipairs(systems) do
        if sys.check() then
            vim.notify('Clipboard: ' .. sys.name, vim.log.levels.INFO)
            return sys
        end
    end
    
    vim.notify('No clipboard detected', vim.log.levels.WARN)
    return nil
end

local clipboard = detect_clipboard()

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================
-- FIX 2: Correcting "Corrupted" Paste Data
-- Added trim to remove trailing newlines added by system shells
local function paste_from_system()
    if not clipboard then
        vim.notify('No clipboard available', vim.log.levels.ERROR)
        return nil
    end
    
    local text = vim.fn.system(clipboard.paste_cmd)
    if vim.v.shell_error == 0 then
        -- Remove trailing newline often added by terminal clipboard tools
        return text:gsub("\r\n$", ""):gsub("\n$", "")
    else
        vim.notify('✗ Paste failed', vim.log.levels.ERROR)
        return nil
    end
end
-- ============================================================================
-- KEYMAPS
-- ============================================================================

-- FIX 1: The 'yc' Binding (Copy to system)
-- Normal mode: yc (works with motions, e.g., yciw)
vim.keymap.set('n', 'yc', function()
    -- Set an operatorfunc to handle the motion
    _G.copy_operator = function(type)
        local saved_reg = vim.fn.getreg('"')
        local saved_reg_type = vim.fn.getregtype('"')
        
        if type == 'v' then
            vim.cmd('normal! `[v` ]y')
        elseif type == 'char' then
            vim.cmd('normal! `[v`]y')
        elseif type == 'line' then
            vim.cmd('normal! `[V`]y')
        end
        
        local text = vim.fn.getreg('"')
        copy_to_system(text)
        
        -- Restore original register
        vim.fn.setreg('"', saved_reg, saved_reg_type)
    end
    
    vim.o.operatorfunc = 'v:lua.copy_operator'
    return 'g@'
end, { expr = true, desc = 'Copy motion to system clipboard' })

-- Visual mode: yc (Copy selection)
vim.keymap.set('v', 'yc', function()
    -- Yank the selection to the unnamed register
    vim.cmd('normal! "y')
    local text = vim.fn.getreg('"')
    copy_to_system(text)
end, { silent = true, desc = 'Copy selection to system clipboard' })



-- 3. <leader>pc - Paste last copied item from system clipboard
vim.keymap.set('n', '<leader>pc', function()
    local text = paste_from_system()
    if text and text ~= '' then
        -- Set to both + and * registers for consistency
        vim.fn.setreg('+', text)
        vim.fn.setreg('*', text)
        vim.cmd('normal! "+p')
    else
        vim.notify('Clipboard is empty', vim.log.levels.WARN)
    end
end, { 
    silent = true, 
    desc = 'Paste from system clipboard' 
})

