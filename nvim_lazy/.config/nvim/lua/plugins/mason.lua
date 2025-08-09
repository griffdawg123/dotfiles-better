return {
  "mason-org/mason-lspconfig.nvim",
  opts = {
      ensure_installed = {
        "lua_ls",
        "gopls",
        "eslint",
        "pyright",
      },
      automatic_installation = true,
  },
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
  },
}
