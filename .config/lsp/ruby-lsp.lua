-- https://shopify.github.io/ruby-lsp/editors#built-in-vimlsp
-- NOTE: NeoVim 0.11+
return {

  filetypes = { "ruby" },

  cmd = { "ruby-lsp" } -- or { "bundle", "exec", "ruby-lsp" },

  root_markers = { "Gemfile", ".git" },

  init_options = {
    formatter = 'standard',
    linters = { 'standard' },
    addonSettings = {
      ["Ruby LSP Rails"] = {
        enablePendingMigrationsPrompt = false,
      },
    },
  },
}