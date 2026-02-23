return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = {
    options = {
      theme = "catppuccin",
      globalstatus = true,
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = { "diagnostics", { "filename", path = 1 } },
      lualine_x = { "diff", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
  },
}
