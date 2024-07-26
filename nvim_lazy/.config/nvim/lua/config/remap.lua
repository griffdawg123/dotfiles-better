vim.g.mapleader = " "
--vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "<c-k>", ':wincmd k<CR>')
vim.keymap.set("n", "<c-j>", ':wincmd j<CR>')
vim.keymap.set("n", "<c-h>", ':wincmd h<CR>')
vim.keymap.set("n", "<c-l>", ':wincmd l<CR>')
