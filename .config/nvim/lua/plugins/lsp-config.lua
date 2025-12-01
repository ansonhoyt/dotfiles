-- Language Servers
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
        "eslint", -- JavaScript/TypeScript linting
        "pyright", -- Python
        "jsonls", -- JSON
      }
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    }
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "stylua", -- Lua formatter
        "prettier", -- JS/TS formatter
        "ruff", -- Python formatter + linter (replaces black, isort, flake8, pylint)
      }
    },
    dependencies = { "mason-org/mason.nvim" }
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

      vim.lsp.config.eslint = {
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        root_dir = vim.fs.root(0, { ".eslintrc", ".eslintrc.js", ".eslintrc.json", "package.json" })
      }

      vim.lsp.config.jsonls = {
        settings = {
          json = {
            validate = { enable = true }
          }
        }
      }

      vim.lsp.config.pyright = {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",  -- "off" | "basic" | "strict"
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            }
          }
        }
      }

      vim.lsp.enable({ 'lua_ls', 'ts_ls', 'ruby_lsp', 'eslint', 'jsonls', 'pyright' })

      -- Configure diagnostic display
      vim.diagnostic.config({
        virtual_text = true,  -- Show errors at end of line
        signs = true,         -- Show in signcolumn
        underline = true,     -- Underline errors
        severity_sort = true, -- Sort by severity (errors first)
      })

      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
      vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, {})

      -- Signature help while typing (shows function parameters)
      vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, {})

      -- Navigate diagnostics (errors/warnings)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, {})
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, {})
    end
  }
}
