require("b_water.init")
require("b_water.remap")
		-- BASIC EDITOR SETTINGS --


vim.o.number = true --Show line numbers
vim.o.relativenumber = true --Show relative numbers
vim.o.cursorline = true --Highlight the current line

vim.cmd('syntax on') --Enable syntax highlighting

vim.o.mouse = 'a' --Enable mouse support

vim.o.scrolloff = 8 --Set a confortable scroll offset

vim.o.signcolumn = 'yes' --Set the witdh of the sign column

vim.o.clipboard = 'unnamedplus' --Use system clipboard for copy/paste 



		-- TABS AND INDENTATION --
		
-- Set tab width to 4 spaces
vim.o.tabstop = 4
vim.o.shiftwidth = 4


vim.o.expandtab = true -- Use spaces instead of tabs

-- Enable auto-indentation
vim.o.autoindent = true
vim.o.smartindent = true


		-- SEARCH SETTINGS --


vim.o.hlsearch = true  --Highlight search results

vim.o.incsearch = true  --Enable incremental search

vim.o.ignorecase = true --Ignore case in search patterns

vim.o.smartcase = true --Override ignorecase if search pattern contains uppercase


		-- UI ENHANCEMENTS --


-- Enable persistent undo
vim.o.undofile = true

-- Show matching brackets
vim.o.showmatch = true

-- Set command line height to 2 lines
vim.o.cmdheight = 2

-- Enable split windows to open below and to the right
vim.o.splitbelow = true
vim.o.splitright = true

-- Disable swap files (useful when using version control)
vim.o.swapfile = false



		-- PERFORMANCE TWEAKS --


-- Reduce update time
vim.o.updatetime = 300

-- Set timeout length for key sequences
vim.o.timeoutlen = 500



		-- FILETYPE-SPECIFIC SETTINGS --

vim.cmd([[
    autocmd Filetype c setlocal cindent tabstop=4 shiftwidth=4 noexpandtab
    autocmd Filetype cpp setlocal cindent tabstop=4 shiftwidth=4 noexpandtab
    autocmd FileType rs setlocal tabstop=4 shiftwidth=4 noexpandtab
    autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab
    autocmd FileType javascript,typescript setlocal tabstop=2 shiftwidth=2 expandtab
    autocmd BufRead,BufNewFile *.conf set filetype=conf
    autocmd BufRead,BufNewFile *.json set filetype=json
    autocmd BufRead,BufNewFile *.yaml set filetype=yaml
]])

    -- LAZY NVIM CONFIGURATION --
vim.opt.rtp:prepend("~/.local/share/nvim/lazy/lazy.nvim")
-- Lazy.nvim configuration for your plugins

require('lazy').setup({

  -- Lazy.nvim can manage itself

  {

    'folke/lazy.nvim',

    version = "*",

  },

  {
      'nanotee/zoxide.vim'
  },

  -- Telescope for fuzzy finding

  {

    'nvim-telescope/telescope.nvim',

    version = '0.1.6',

    dependencies = { 'nvim-lua/plenary.nvim' },

    cmd = 'Telescope', -- Lazy load on command

  },

  -- Telescope for file-browser
  {
      'nvim-telescope/telescope-file-browser.nvim',

      dependencies = { 'nvim-telescope/telescope.nvim' , 'nvim-lua/plenary.nvim' }
  },

  -- Kanagawa colorscheme

  {

    'rebelot/kanagawa.nvim',

    config = function()

      vim.cmd('colorscheme kanagawa')

    end

  },

  -- 42header plugin

  {
      "Diogo-ss/42-header.nvim",
      cmd = {"Stdheader"},
      keys = {"<F1>"},
      opts = {
          default_map = true,--Default mapping <F1> in normal mode.
          auto_update = true,--Update header when saving.
          user = "oilyine-",-- 42 username
          mail = "oleg.ilyine@student42.luxembourg.lu",-- Email
          -- add other options
    },
    config = function(_, opts)
        require("42header").setup(opts)
    end

  },

  -- 42 norminette config

  {
        "hardyrafael17/norminette42.nvim",
        config = function()
        local norminette = require("norminette")
        norminette.setup({
                        runOnSave = true,
                        maxErrorsToShow = 5,
                        active = true,
        })
    end
},

  -- Which-key, Neovim keymaps reminder. Shows available keyblindings

  {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
},

{
        "christoomey/vim-tmux-navigator",
        lazy = false,  -- Set to false to load the plugin on startup
        config = function()
            -- Disable default mappings if you want to customize the mappings
            vim.g.tmux_navigator_no_mappings = 1

            -- Use <Ctrl-hjkl> for navigation between tmux panes and Neovim splits
            vim.keymap.set('n', '<C-h>', ':TmuxNavigateLeft<CR>', { silent = true })
            vim.keymap.set('n', '<C-j>', ':TmuxNavigateDown<CR>', { silent = true })
            vim.keymap.set('n', '<C-k>', ':TmuxNavigateUp<CR>', { silent = true })
            vim.keymap.set('n', '<C-l>', ':TmuxNavigateRight<CR>', { silent = true })
        end
},

{
    "David-Kunz/gen.nvim",
    opts = {
        model = "mistral", -- The Defualt model to use.
        quit_map = "q", -- set keymap to close the response window
        retry_map = "<c-r>", -- set keymap to re-send the current prompt 
        accept_map = "<c-cr>", -- set keymap to replace the previous selection with the last results
        host = "localhost", -- The host running the Ollama service
        port = "11434", -- The port on which the Ollama service is listening
        display_mode = "float", -- The display mode. Can be "float" or "split" or "horizontal-split".
        show_prompt = false, -- Shows the prompt submitted to Ollama.
        show_model = false, -- Displays which model you are using at the beginning of your chat session
        no_auto_close = false, -- Never closes the window automatically
        file = false, -- Write the payload to a temporary file to keep the command short 
        hidden = false, -- Hide the generation window (if true, will implicitly set `prompt.replace = true`), requires Neovim >= 0.10
        init = function(options) pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,

        command = function(options)
            local body = {model = options.model, stream = true}
            return "curl --silent --no-buffer -X POST http://" .. options.host .. ":" .. options.port .. "api/chat -d $body"
        end,
        -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
        -- This can also be a command string.
        -- The executed command must return a JSON object with { response, context }
        -- (context property is optional).
        -- list_models = '<omitted lua function>', -- Retrieves a list of model names
        debug = false -- Prints errors and the command which is run.

    }
},


  -- Dashboard.nvim: Fast start screen plugin of neovim

  {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    require('dashboard').setup {
      -- Hyper config
	config = {
  		shortcut = {
    		-- action can be a function type
            -- File Navigation shortcuts
    			{ desc = "Find files", group = "File", key = "<leader>ff", action = "Telescope find_files" }, --Open files (Telescope)
    			{ desc = "Recent files", group = "File", key = "<leader>fr", action = "Telescope oldfiles" }, -- Recent files (Telescope)
    			{ desc = "File Browser", group = "File", key = "<leader>fb", action = "NERDTreeToggle" }, -- Browse Files (NERDTree)
    			{ desc = "Grep Projects", group = "Search", key = "<leader>fg", action = "Telescope find_files" }, -- Grep Project (Telescope)
            -- Editing and refactoring
    			{ desc = "Rename Symbol", group = "Code", key = "<leader>rn", action = "lua vim.lsp.buf.rename()" }, -- Rename Symbol (LSP)
    			{ desc = "Go To Definition", group = "Code", key = "<leader>gd", action = "lua vim.lsp.buf.definition()" }, -- Go To Definition (LSP)
            -- Window Management
    			{ desc = "Horizontal split", group = "Window", key = "<leader>sh", action = "split" }, -- Horizontal split
    			{ desc = "Vertical split", group = "Window", key = "<leader>sv", action = "vsplit" }, -- Vertical split
                { desc = "Close window", group = "Window", key = "<leader>q", action = "close" }, -- Close split
            -- Buffer Management
    			{ desc = "Next buffer", group = "Buffer", key = "<leader>bn", action = "bnext" }, -- Next Buffer
    			{ desc = "Previous buffer", group = "Buffer", key = "<leader>bp", action = "bprev" }, -- Previous Buffer
    			{ desc = "Close buffer", group = "Buffer", key = "<leader>bc", action = "bdelete" }, -- Close Buffer
            -- Git Integration 
    			{ desc = "Git Status", group = "Git", key = "<leader>gs", action = "Git" }, -- Git status (vim-fugitive) 
    			{ desc = "Git Diff", group = "Git", key = "<leader>gd", action = "Gdiffsplit" }, -- Git Diff (vim-fugitive)
    			{ desc = "Git Commit", group = "Git", key = "<leader>gc", action = "Git Commit" }, -- Git Commit (vim-fugitive)
            -- Utility Shortcuts 
    			{ desc = "Toggle Comment", group = "Utility", key = "<leader>c", action = "Commentary" }, -- Toggle Comment
    			{ desc = "Git Commit", group = "Utility", key = "<leader>w", action = "write" }, -- Save File
    			{ desc = "Git Commit", group = "Utility", key = "<leader>gc", action = "qa" }, -- Quit File
            -- Plugin-specific Shortcuts
    			{ desc = "Harpoon Menu", group = "Harpoon", key = "<leader>hm", action = "lua require('harpoon.ui').toggle_quick_menu()" }, -- (harpoon)
    			{ desc = "Add File to Harpoon", group = "Harpoon", key = "<leader>ha", action = "lua require('harpoon.mark').add_file()" }, -- (harpoon)
  			},
  			packages = { enable = true }, -- show how many plugins neovim loaded
  			-- limit how many projects list, action when you press key or enter it will run this action.
  			-- action can be a function type, e.g.
  			-- action = func(path) vim.cmd('Telescope find_files cwd=' .. path) end
  			project = { enable = true, limit = 8, icon = '📂', label = '', action = function(path) vim.cmd('Telescope find_files cwd=' .. path) end},
  			mru = { limit = 10, icon = '🗂️', label = 'Recent Files', cwd_only = false },
  			footer = {}, -- footer content
		}
    }
  	end,
  	dependencies = {{'nvim-tree/nvim-web-devicons'}}
},

  -- Nvim Tree
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        -- Add your configurations here
        open_on_tab = false,
        update_focused_file ={
            enable = true, -- Update on the current file
            update_cwd = true,
        },
        view = {
          width = 30,
          side = 'left', -- Side of the tree
        },
        renderer = {
          root_folder_modifier = ":t", -- Display only the tail of the root directory
        },
        hijack_cursor = true, -- Keep the cursor on the first letter of the file
      })
    end,
  },

  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          offsets = { { filetype = "NvimTree", text = "Explorer", text_align = "center" } },
          show_buffer_close_icons = false,
          show_close_icon = false,
        },
      })
    end,
  },

  -- Lualine
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          theme = "iceberg_dark", -- See THEMES.md in lualine.git for more 
          section_separators = '',
          component_separators = '',
        },
      })
    end,
  },

  -- Fuzzy Find
  {
    "junegunn/fzf.vim",
    run = function()
      vim.fn['fzf#install']()  -- Automatically install fzf
    end,
  },

  -- Treesitter for syntax highlighting

  {

    'nvim-treesitter/nvim-treesitter',

    build = ':TSUpdate', -- Runs the update command after installing

  },

  -- Treesitter Playground (useful for debugging Treesitter queries)packer/start/nvim-treesitter/queries/matlab:

  {

    'nvim-treesitter/playground',

    cmd = 'TSPlaygroundToggle', -- Lazy load on command

  },

  -- Harpoon for quick navigation between files

  {

    'theprimeagen/harpoon',

    dependencies = { 'nvim-lua/plenary.nvim' }, -- Harpoon uses plenarypacker/start/nvim-treesitter/queries/meson:

    event = "VeryLazy" -- Load after initialization for better performance

  },

  -- Undotree for visualizing undo history

  {

    'mbbill/undotree',

    cmd = 'UndotreeToggle', -- Lazy load on command

  },

  -- Vim-fugitive for Git integration

  {

    'tpope/vim-fugitive',

    cmd = { 'Git', 'Gdiffsplit', 'Gread', 'Gwrite', 'Ggrep', 'Gmove', 'Gdelete', 'Gedit' }, -- Lazy load on specific Git commands

  },

  -- Tmux navigator for seamless movement between tmux and nvim
  {
      "christoomey/vim-tmux-navigator",
      config = function()
          vim.g.tmux_navigator_no_mappings = 1
      end
  },

  -- Markdown preview plugin
  {
      "iamcco/markdown-preview.nvim",
      build = "cd app & npm install",
      ft = "markdown",
      config = function()
          vim.g.mkdp_auto_start = 1 -- Automatically start preview when opening a mardkown file
      end
  },

  --Mason-tool pour gerer les linters et formatteurs
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    requires = {'williamboman/mason.nvim'}
  },

  -- nvim.lint
  {
      'mfussenegger/nvim-lint'
  },

  --Formatteur
  {
      'mhartington/formatter.nvim'
  },

  -- LSP Configuration with LSP Zero (v3.x branch)

  {

    'VonHeikemen/lsp-zero.nvim',

    branch = 'v3.x',

    dependencies = {

      -- LSP Support

      {'neovim/nvim-lspconfig'}, -- Core LSP

      {'williamboman/mason.nvim'}, -- Package manager for LSP servers.scm  highlights.scm  indents.scm  injections.scm

      {'williamboman/mason-lspconfig.nvim'}, -- Mason integration with lspconfig

      -- Autocompletion

      {'hrsh7th/nvim-cmp'}, -- Main completion engine

      {'hrsh7th/cmp-buffer'}, -- Buffer completions

      {'hrsh7th/cmp-path'}, -- Path completions

      {'hrsh7th/cmp-nvim-lsp'}, -- LSP completions

      {'hrsh7th/cmp-nvim-lua'}, -- Lua completions (for Neovim config)packer/start/nvim-treesitter/queries/objc:

      {'saadparwaiz1/cmp_luasnip'}, -- Snippet completions


      -- Snippets

      {'L3MON4D3/LuaSnip'}, -- Snippet engine

      {'rafamadriz/friendly-snippets'}, -- Collection of snippets

  },

    config = function()

      -- Add your LSP zero setup here

      local lsp = require('lsp-zero')

      lsp.preset('recommended')

      require('mason').setup()
      require('mason-lspconfig').setup({
      	ensure_installed = {'ltex'},
	})
      lsp.configure('ltex', {
          settings = {
              ltex ={
                  language = "en",
                  diagnosticSeverity = "information",
                  sentenceCacheSize = 2000,
                  completionEnabled = true,
                  checkFrequency = "save"
              }
          }
      })

      lsp.setup()
    end
    },
})
