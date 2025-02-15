local lsp = require('lsp-zero')

lsp.preset("recommended")

-- Setup mason and mason-lspconfig
require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        'ansiblels', 'arduino_language_server','ast_grep', 'bashls',
        'cmake', 'clangd', 'cssls', 'docker_compose_language_service', 'golangci_lint_ls',
        'html', 'jdtls', 'eslint', 'jsonls', 'kotlin_language_server',
        'ols', 'lua_ls', 'matlab_ls', 'pyright', 'phpactor',
        'powershell_es', 'rust_analyzer', 'sqls','ts_ls', 'terraformls',
        'vuels', 'zls'
    },

    handlers = {
        -- Default handler for all servers
        function(server_name)
            require('lspconfig')[server_name].setup({})
        end,
        -- Custom handler for lua_ls
        ['lua_ls'] = function()
            require('lspconfig').lua_ls.setup({
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' }
                        }
                    }
                }
            })
        end,
    }
})

-- Function to determine if a line is a comment or string
local function is_comment_or_string(line)
    return line:match("^%s*//") or   -- Single line comment for languages like JavaScript/C++
           line:match("^%s*#") or    -- Single line comment for Python
           line:match("^%s*--") or   -- Single line comment for Lua
           line:match("%b''") or     -- Single quotes
           line:match('%b""')        -- Double quotes
end

-- Function to filter out diagnostics in comments
local function filter_diagnostics_in_comments(diagnostic)
    if diagnostic.lnum == nil then
        return false
    end

    local bufnr = diagnostic.bufnr
    local line = vim.api.nvim_buf_get_lines(bufnr, diagnostic.lnum, diagnostic.lnum + 1, false)[1]

    return not is_comment_or_string(line)
end

-- Override the LSP diagnostics handler
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
    if result.diagnostics == nil then return end

    -- Filter dianostics
    result.diagnostics = vim.tbl_filter(filter_diagnostics_in_comments, result.diagnostics)

    local bufnr = vim.uri_to_bufnr(result.uri)
    local namespace = ctx.client_id

    -- Use the client-specific namespace to set diagnostics
    vim.diagnostic.set(namespace, bufnr, result.diagnostics, config)
end

-- Setup completion
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- Luasnip integration
        end,
    },
    mapping = {
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

        -- Super tab mapping for jumping between snippets
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' }, -- LSP completions
        { name = 'luasnip' },  -- Snippet completions
    }, {
        { name = 'buffer' },   -- Buffer completions
        { name = 'path' },     -- File path completions
    })
})

-- Setup cmdline completion
cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer' }
    }
})

cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

-- Setup lspconfig (integrating Mason and nvim-cmp)
local capabilities = require('cmp_nvim_lsp').default_capabilities() -- Call on cmp_nvim_lsp default capabilities on LSPs
require('lspconfig')['ols'].setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)-- handle key mappings or client-specific actions (Reference to the vim.lsp.handlers function below, line 37)
    end,
    handlers = {
        ["textDocument/publishDiagnostics"] = custom_publish_diagnostics
    }
}
require('lspconfig')['bashls'].setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)-- handle key mappings or client-specific actions (Reference to the vim.lsp.handlers function below, line 37)
    end,
    handlers = {
        ["textDocument/publishDiagnostics"] = custom_publish_diagnostics
    }
}
require('lspconfig')['clangd'].setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)-- handle key mappings or client-specific actions (Reference to the vim.lsp.handlers function below, line 37)
    end,
    handlers = {
        ["textDocument/publishDiagnostics"] = custom_publish_diagnostics
    }
}
require('lspconfig')['ts_ls'].setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)-- handle key mappings or client-specific actions (Reference to the vim.lsp.handlers function below, line 37)
    end,
    handlers = {
        ["textDocument/publishDiagnostics"] = custom_publish_diagnostics
    }
}
require('lspconfig')['pyright'].setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)-- handle key mappings or client-specific actions (Reference to the vim.lsp.handlers function below, line 37)
    end,
    handlers = {
        ["textDocument/publishDiagnostics"] = custom_publish_diagnostics
    }
}

require('lspconfig')['lua_ls'].setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)-- handle key mappings or client-specific actions (Reference to the vim.lsp.handlers function below, line 37) 
    end,
    handlers = {
        ["textDocument/publishDiagnostics"] = custom_publish_diagnostics
    }
}
require('lspconfig')['ast_grep'].setup ({
    capabilities = capabilities,
    on_attach = function(client, bufnr)-- handle key mappings or client-specific actions (Reference to the vim.lsp.handlers function below, line 37)    
    end,
    handlers = {
        ["textDocument/publishDiagnostics"] = custom_publish_diagnostics
    },
    settings = {
        -- Custom ast_grep settings if needed (none are required by default, but you can specify project-specific rules here)
    },
    flags = {
        debounce_text_changes = 150 -- diagnostics refresh control, defualt to 150 ms 
    },
    handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
        ["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
  }
})

-- Setup LSP on_attach
lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts) -- Go to Definition
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts) -- Shoe hover information
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts) -- Search workspace symbols
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts) -- Show diagnostics in a floating window
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts) -- Go to next diagnostic (error/warning)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts) -- Go to previous diagnostic 
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts) -- Trigger code action 
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts) -- Show references of the symbol under the cursor
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts) -- Rename symbol under cursor 
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts) -- Show signature help in insert mode
end)

lsp.setup() -- Closing lsp.setup

--[[
    gd (vim.lsp.buf.definition()):
    Mode: Normal
    Action: Jumps to the definition of the symbol under the cursor. If you're on a function name, variable, or class, pressing gd will navigate to where that symbol is defined in your project.

    K (vim.lsp.buf.hover()):
    Mode: Normal
    Action: Displays hover information about the symbol under the cursor in a floating window. This could be documentation, type information, or any relevant details the LSP provides.

    <leader>vws (vim.lsp.buf.workspace_symbol()):
    Mode: Normal
    Action: Searches for symbols (functions, variables, etc.) across the entire workspace (project) and lists them. Useful for navigating large codebases.

    <leader>vd (vim.diagnostic.open_float()):
    Mode: Normal
    Action: Shows diagnostics (errors, warnings, etc.) related to the line you're currently on in a floating window.

    [d (vim.diagnostic.goto_next()):
    Mode: Normal
    Action: Jumps to the next diagnostic (error/warning) in the buffer.

    ]d (vim.diagnostic.goto_prev()):
    Mode: Normal
    Action: Jumps to the previous diagnostic (error/warning) in the buffer.

    <leader>vca (vim.lsp.buf.code_action()):
    Mode: Normal
    Action: Opens a code action menu. Code actions are suggested fixes or refactorings provided by the LSP, such as "quick fix", "add missing import", etc.

    <leader>vrr (vim.lsp.buf.references()):
    Mode: Normal
    Action: Lists all references to the symbol under the cursor, showing where it is used in the code.

    <leader>vrn (vim.lsp.buf.rename()):
    Mode: Normal
    Action: Renames the symbol under the cursor across your project. This updates all usages of that symbol to the new name.

    <C-h> (vim.lsp.buf.signature_help()):
    Mode: Insert
    Action: While you're typing inside a function, pressing <C-h> will show the signature (parameters and return type) of that function in a floating window.
]]--
