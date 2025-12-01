return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      -- https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#supported-languages
      ensure_installed = {"lua", "javascript", "python"},
      auto_install = true, -- install missing parsers on open
      highlight = { enable = true },
      indent = { enable = true }
    })
  end
}
