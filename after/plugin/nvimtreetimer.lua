
local nvim_tree_timer = nil

-- Function to close nvim-tree if it is open
local function close_nvim_tree()
    if require('nvim-tree.view').is_visible() then
        require('nvim-tree.view').close()
    end
end

-- Function to start or restart the inactivity timer
local function start_nvim_tree_timer()
    if nvim_tree_timer then
        nvim_tree_timer:stop() -- Stop the existing timer if it's running
    else
        nvim_tree_timer = vim.loop.new_timer()
    end

    -- start the timer to close nvim-tree after 60 seconds (60000 ms)
    nvim_tree_timer:start(60000, 0, vim.schedule_wrap(close_nvim_tree))
end

-- Automatically start the timer when nvim-tree is opened
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "NvimTree_*",
    callback = start_nvim_tree_timer,
})

-- Reset the timer whenever there's activity in the tree
vim.api.nvim_create_autocmd("CursorMoved", {
    pattern = "NvimTree_*",
    callback = start_nvim_tree_timer,
})
