return {
  "neovim/nvim-lspconfig",
  opts = {},
  dependencies = {
    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          -- See the configuration section for more details
          -- Load luvit types when the `vim.uv` word is found
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
  },
  config = function(_, opts)
    -- Configure LSP servers
    require("lspconfig").lua_ls.setup({
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" }, -- Recognize 'vim' as a global variable
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true), -- Include Neovim runtime files
          },
        },
      },
    })
    -- local  mason_lspconfig = require("mason-lspconfig")
    -- for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
    --   if server ~= "lua_ls" then
    --     require("lspconfig")[server].setup({})
    --   end
    -- end
  end,
}
