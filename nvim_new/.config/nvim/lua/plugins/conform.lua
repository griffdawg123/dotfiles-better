return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = "ConformInfo",
  config = function()
    require("conform").setup({
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true, -- fallback to LSP if no formatter found
      },
      formatters_by_ft = {
        lua = { "stylua" },
        go = { "goimports", "gofmt" },
        javascript = { "prettier" },
        python = { "black" },
        -- You can set fallback formatters here too
      },
    })
  end,
}

