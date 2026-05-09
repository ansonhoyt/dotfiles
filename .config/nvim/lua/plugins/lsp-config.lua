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
        "basedpyright", -- Python type checker (community fork of pyright)
        "ruff", -- Python linter + formatter LSP (replaces black, isort, flake8, pylint)
        "jsonls", -- JSON
        "taplo", -- TOML
        "terraformls", -- Terraform (HashiCorp terraform-ls)
        "tflint", -- Terraform linting
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

      vim.lsp.config.basedpyright = {
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "basic",  -- "off" | "basic" | "standard" | "strict" | "all"
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            }
          }
        }
      }

      -- Ruff: linter + formatter. Disable hover so basedpyright handles it.
      vim.lsp.config.ruff = {
        on_attach = function(client, _)
          client.server_capabilities.hoverProvider = false
        end,
      }

      -- Advertise cmp capabilities to all LSP servers
      vim.lsp.config('*', {
        capabilities = require('cmp_nvim_lsp').default_capabilities()
      })

      -- Upgrade folds from treesitter to LSP when the server supports it.
      -- Register before vim.lsp.enable() so existing buffers (e.g., `nvim file.py`)
      -- don't miss the initial LspAttach fired synchronously by enable().
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client:supports_method('textDocument/foldingRange') then
            local win = vim.api.nvim_get_current_win()
            vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
          end
        end,
      })

      vim.lsp.enable({ 'lua_ls', 'ts_ls', 'ruby_lsp', 'eslint', 'jsonls', 'basedpyright', 'ruff', 'taplo', 'terraformls', 'tflint' })

      -- Configure diagnostic display
      vim.diagnostic.config({
        virtual_text = true,  -- Show errors at end of line
        signs = true,         -- Show in signcolumn
        underline = true,     -- Underline errors
        severity_sort = true, -- Sort by severity (errors first)
      })

      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Find references" })
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Rename symbol" })
      vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Show diagnostic" })
      vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { desc = "Signature help" })
    end
  }
}
