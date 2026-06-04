-- Autosave: needs to be active immediately
vim.schedule(function()
    require('user.config.ide.ide.module_require.autosave')
    require('user.config.ide.ide.module_require.run')
    require('user.config.ide.ide.miniclues')
    require('user.config.ide.ide.undotree')
    require('user.config.ide.file.fzf')
end)
