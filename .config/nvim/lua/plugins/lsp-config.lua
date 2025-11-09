return {
  {
    "mason-org/mason.nvim",
    opts = {}
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls", -- Lua
        "ts_ls", -- TypeScript/JavaScript
        "pyright", -- Python
      }
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    }
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      -- Use new vim.lsp.config API (nvim 0.11+)
      vim.lsp.config.lua_ls = {
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim' } }
          }
        }
      }

      vim.lsp.config.ruby_lsp = {
        cmd = { "ruby-lsp" },
        filetypes = { "ruby" },
        root_dir = vim.fs.root(0, { "Gemfile", ".git" })
      }

      vim.lsp.enable({ 'lua_ls', 'ts_ls', 'ruby_lsp' })

      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
      vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, {})
    end
  }
}
