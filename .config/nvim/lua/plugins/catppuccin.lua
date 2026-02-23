return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  opts = {
    integrations = {
      bufferline = true,
      indent_blankline = { enabled = true, scope_color = "lavender" },
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme "catppuccin"
  end,
}
