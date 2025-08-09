return {
  'folke/trouble.nvim',
  opts = {},
  cmd = "Trouble",
  keys = {
    {"<leader>t", "<CMD>TroubleToggle<CR>"},
    {"<leader>td", "<CMD>Trouble diagnostics<CR>"}
  }
}
