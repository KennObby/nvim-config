-- remap.lua

-- Leader key
vim.g.mapleader = " "

-- Basic navigation remaps
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- Text Editing Remaps
vim.keymap.set('i', '<C-h>', '<C-w>')
vim.keymap.set('n', '<S-p>', 'yyp')
vim.keymap.set('v', '<S-p>', 'y`>pgv')

-- Quick buffer navigation
vim.keymap.set('n', '<C-Tab>', ':bnext<CR>')
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>')

-- Line and text editing remaps
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==')
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==')
vim.keymap.set('n', '<leader>bd', ':bd<CR>')

-- Window management
vim.keymap.set('n', '<leader>v', ':vsplit<CR>')
vim.keymap.set('n', '<leader>s', ':split<CR>')
vim.keymap.set('n', '<leader>o', ':only<CR>')
vim.keymap.set('n', '<leader>lt', ':NvimTreeToggle<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<leader>lf', ':NvimTreeFindFileToggle<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<leader>lq', ':NvimTreeClose<CR>', {noremap = true, silent = true})

-- File operations
vim.keymap.set('n', '<leader>w', ':w<CR>')
vim.keymap.set('n', '<leader>x', ':wq<CR>')
vim.keymap.set('n', '<leader>q', ':q!<CR>')

-- Quick access to the terminal:
vim.keymap.set('n', '<leader>t', ':vsplit | term<CR>')

-- Open Neovim config quickly
vim.keymap.set('n', '<leader>ev', ':vsplit ~/.config/nvim/init.lua<CR>')

-- Open remap.lua file
vim.keymap.set('n', '<leader>r', ':vsplit ~/.config/nvim/lua/b_water/remap.lua<CR>')

-- Show all active maps
vim.keymap.set('n', '<leader>m', ':map<CR>')
vim.keymap.set('n', '<leader>nm', ':nmap<CR>') -- Normal mode
vim.keymap.set('n', '<leader>im', ':imap<CR>') -- Insert mode
vim.keymap.set('n', '<leader>vm', ':vmap<CR>') -- Visual mode

-- Keymap for markdown preview
vim.keymap.set('n', '<leader>mp', ':MarkdownPreview<CR>') -- Start preview
vim.keymap.set('n', '<leader>sp', ':MarkdownPreviewStop<CR>') -- Stop preview

-- Macros for Ollama Mistral prompts
vim.keymap.set('n', '<leader>gp', ':Gen Generate<CR>') -- Generate
vim.keymap.set('n', '<leader>gc', ':Gen Chat<CR>') -- Chat
vim.keymap.set('n', '<leader>gs', ':Gen Summarize<CR>') -- Summarize
vim.keymap.set('n', '<leader>ga', ':Gen Ask<CR>') -- Ask
vim.keymap.set('n', '<leader>gch', ':Gen Change<CR>') -- Change
vim.keymap.set('n', '<leader>geg', ':Gen Enhance_Grammar_Spelling<CR>') -- Enhance Grammar and Spelling
vim.keymap.set('n', '<leader>gew', ':Gen Enhance_Wording<CR>') -- Enhance Wording
vim.keymap.set('n', '<leader>gmc', ':Gen Make_Concise<CR>') -- Make Concise
vim.keymap.set('n', '<leader>gml', ':Gen Make_List<CR>') -- Make List
vim.keymap.set('n', '<leader>gmt', ':Gen Make_Table<CR>') -- Make Table
vim.keymap.set('n', '<leader>grc', ':Gen Review_Code<CR>') -- Review Code
vim.keymap.set('n', '<leader>gec', ':Gen Enhance_Code<CR>') -- Enhance Code
vim.keymap.set('n', '<leader>gcc', ':Gen Change_Code<CR>') -- Change Code
