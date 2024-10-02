return {
    {
        "stevearc/oil.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            default_file_explorer = true,
            view_options = {
                show_hidden = true,
            },
            is_hidden_file = function(name, bufnr)
                return vim.startswith(name, '.')
            end,
            -- This function defines what will never be shown, even when `show_hidden` is set
            is_always_hidden = function(name, bufnr)
                return false
            end,
        },
        keys = {
            {"-", "<CMD>Oil<CR>", desc="Open parent directory"},
        },
    }
}
