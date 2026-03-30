-- which-key: popup showing available keymaps after pressing a prefix
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { "<leader>b", group = "buffer" },
      { "<leader>c", group = "code" },
      { "<leader>f", group = "find" },
      { "<leader>g", group = "git/goto" },
      { "<leader>r", group = "refactor" },
    },
  },
}
