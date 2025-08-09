return {
	"uga-rosa/ccc.nvim",
	config = function()
		vim.opt.termguicolors = true
		local ccc = require("ccc")
		ccc.setup({
			highlighter = {
				auto_enable = true,
				lsp = true,
			},
			outputs = {
				require("ccc.output.css_rgba"),
				require("ccc.output.css_rgb"),
				require("ccc.output.hex"),
			},
		})
	end,
}
