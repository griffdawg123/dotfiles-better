vim.keymap.set('n', '<leader>t', '<CMD>TestNearest<CR>')
vim.keymap.set('n', '<leader>T', '<CMD>TestSuite<CR>')
vim.keymap.set('n', '<leader>f', '<CMD>TestFile<CR>')
vim.cmd("let test#strategy = 'vimux'")
