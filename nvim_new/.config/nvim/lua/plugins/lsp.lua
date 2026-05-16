return {
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			{ "williamboman/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "rust_analyzer" },
			})

			vim.diagnostic.config({
				virtual_text = {
					spacing = 2,
					prefix = "●", -- could be '■', '▎', 'x'
				},
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
			})

			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			vim.lsp.config("rust_analyzer", {
				capabilities = capabilities,
				settings = {
					["rust-analyzer"] = {
						completion = {
							autoimport = {
								enable = true,
							},
						},
						cargo = {
							allFeatures = true,
						},
					},
				},
			})
			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})
		end,
	},
}
