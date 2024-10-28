local builtin = require('telescope.builtin')

-- File search
vim.keymap.set('n', '<leader>ff', function()
    builtin.find_files({cwd = "~"})
end)

-- Live grep
vim.keymap.set('n', '<leader>lg', builtin.live_grep, {})

-- Buffer search
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})

-- Recent files
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, {})

-- Help tags
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- Search current buffer
vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, {})

-- Dotfiles finder
vim.keymap.set('n', '<leader>fd', function()
    builtin.find_files({
        prompt_title = "< Dotfiles >",
        cwd = "~/.config/nvim",
        hidden = true
    })
end)

-- LSP keybindings
vim.keymap.set('n', 'gd', builtin.lsp_definitions, {})
vim.keymap.set('n', 'gr', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>ws', builtin.lsp_workspace_symbols, {})

-- LazyGit
vim.keymap.set('n', '<leader>gg', ":LazyGit<CR>", { noremap = true, silent = true })
