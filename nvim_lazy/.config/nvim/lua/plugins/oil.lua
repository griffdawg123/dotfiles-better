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
		},
		keys = {
			{"-", "<CMD>Oil<CR>", desc="Open parent directory"},
		},
	}
}
