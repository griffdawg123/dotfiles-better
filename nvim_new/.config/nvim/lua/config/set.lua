vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.g.mapleader = " "
vim.o.guifont = "0xProto Mono Nerd Font Mono:h14"

vim.cmd([[colorscheme tokyonight]])

vim.opt.clipboard = "unnamedplus"

vim.opt.winborder = "rounded"

vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.bmp" },
	callback = function()
		local file = vim.fn.expand("%:p")
		vim.cmd("enew") -- open empty buffer
		vim.cmd("setlocal buftype=nofile bufhidden=hide noswapfile")
		vim.cmd("term viu -w $(tput cols) " .. vim.fn.shellescape(file))
		vim.cmd("startinsert") -- go into terminal mode
	end,
})

vim.opt.wrap = true

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99 -- open all folds by default
