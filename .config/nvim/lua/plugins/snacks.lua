-- snacks.nvim: QoL utilities by folke
-- bufdelete: delete buffers without closing windows (preserves neo-tree sidebar layout)
return {
  "folke/snacks.nvim",
  lazy = false,
  opts = {
    bufdelete = { enabled = true },
    image = { enabled = true }, -- inline image rendering via Ghostty kitty graphics protocol
  },
  keys = {
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
  },
}
