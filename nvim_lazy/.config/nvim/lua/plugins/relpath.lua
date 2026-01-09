return {
	"griffdawg123/relpath.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
	keys = {
		{ "<leader>fr", "<cmd>RelPath<CR>", desc = "Find Relative Path" },
	},
	opts = {},
}
