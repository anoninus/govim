-- Floating window defaults
local float_opts = {
  border     = 'rounded',
  max_width  = 80,
  max_height = 20,
}

-- 0.12: configure all servers via vim.lsp.config
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities({
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport          = true,
          insertReplaceSupport    = true,
          labelDetailsSupport     = true,
          commitCharactersSupport = true,
          deprecatedSupport       = true,
          preselectSupport        = true,
          documentationFormat     = { 'markdown', 'plaintext' },
          resolveSupport = {
            properties = { 'documentation', 'detail', 'additionalTextEdits' },
          },
        },
      },
    },
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration    = true,
        relativePatternSupport = true,
      },
    },
  }),

  -- 0.12: handlers live inside vim.lsp.config now
  handlers = {
    ['textDocument/hover']         = vim.lsp.with(vim.lsp.handlers.hover,            float_opts),
    ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help,   float_opts),
  },
})

vim.defer_fn(function()
  require('luasnip.loaders.from_vscode').lazy_load()
end, 100)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then return end

    if client.name == 'marksman' or client.name == 'gdscript' then
      client.server_capabilities.documentHighlightProvider = false
    end

    local opts = { buffer = ev.buf, silent = true }
    vim.keymap.set('n', 'K',     vim.lsp.buf.hover,          opts)
    vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
  end,
})

vim.keymap.set('n', '<leader>ti', function()
  local buf     = vim.api.nvim_get_current_buf()
  local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
  vim.lsp.inlay_hint.enable(not enabled, { bufnr = buf })
end, { desc = 'Toggle Inlay Hints' })
