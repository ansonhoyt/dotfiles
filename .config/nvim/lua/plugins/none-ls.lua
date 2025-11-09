-- Linting and Formatting
-- https://github.com/nvimtools/none-ls.nvim
-- NOTE: eventually LSPs may cover these (as ruby-lsp has done with rubocop)
return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim"
  },
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        -- Auto-installed via mason-tool-installer (see lsp-config.lua and :Mason)
        null_ls.builtins.formatting.stylua, -- Lua
        null_ls.builtins.formatting.prettier, -- JS
        null_ls.builtins.formatting.black, -- Python
        null_ls.builtins.formatting.isort, -- Python
      },
    })

    vim.keymap.set('n', '<leader>gf', vim.lsp.buf.format, {})
  end
}
