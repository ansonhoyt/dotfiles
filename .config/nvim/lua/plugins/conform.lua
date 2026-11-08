-- Formatting via conform.nvim
-- https://github.com/stevearc/conform.nvim
-- Replaces none-ls. Diagnostics live in LSPs (ruff, eslint, etc.)
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_organize_imports", "ruff_format" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
    },
    -- Toggle with :FormatDisable / :FormatEnable (buffer-local with !)
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 1000, lsp_format = "fallback" }
    end,
  },
  init = function()
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, { desc = "Disable autoformat (! for buffer)", bang = true })

    vim.api.nvim_create_user_command("FormatEnable", function(args)
      if args.bang then
        vim.b.disable_autoformat = false
      else
        vim.g.disable_autoformat = false
      end
    end, { desc = "Enable autoformat (! for buffer)", bang = true })

    vim.keymap.set({ "n", "v" }, "<leader>gf", function()
      require("conform").format({ async = true, lsp_format = "fallback" })
    end, { desc = "Format buffer/range" })
  end,
}
