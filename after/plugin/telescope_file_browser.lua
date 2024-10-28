local telescope = require('telescope')

-- Load the file browser extension
telescope.load_extension('file_browser')

-- Set keybindings for the file browser
vim.keymap.set('n', '<leader>fb', ":Telescope file_browser<CR>", { noremap = true, silent = true })

-- Optional: Custom file browser with specific options
vim.keymap.set('n', '<leader>fB', function()
    telescope.extensions.file_browser.file_browser({
        path = "~/your/desired/path",  -- Customize this path
        hidden = true,  -- Show hidden files
        respect_gitignore = false  -- Disable respecting .gitignore
    })
end)
