-- https://shopify.github.io/ruby-lsp/editors#built-in-vimlsp
-- NOTE: NeoVim 0.11+
-- Lives in after/lsp/ (not lsp/) because rtp lsp files merge later-wins:
-- nvim-lspconfig's ruby_lsp.lua would override init_options otherwise.
return {

  -- eruby: Ruby features inside <% %> only; HTML delegation needs client
  -- support ruby-lsp only ships for VS Code (Herb covers HTML if wanted)
  filetypes = { "ruby", "eruby" },

  cmd = { "ruby-lsp" }, -- or { "bundle", "exec", "ruby-lsp" },

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

