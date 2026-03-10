-- Neo-tree file explorer
-- https://github.com/nvim-neo-tree/neo-tree.nvim?tab=readme-ov-file#minimal-example-for-lazy
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  cmd = "Neotree",
  keys = {
    { "<C-n>", "<cmd>Neotree filesystem reveal left<cr>", desc = "File Explorer" },
  },
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,          -- show filtered items dimmed
        hide_dotfiles = true,    -- filter dotfiles (shown dimmed via visible)
        hide_gitignored = true,
      },
    },
  },
}
