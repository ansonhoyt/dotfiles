return {
  "rmagatti/auto-session",
  lazy = false,
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    suppressed_dirs = { "~/", "~/Downloads", "/tmp" },
    -- Close neo-tree before saving the session. Deliberately NOT
    -- pre_save_cmds = { "Neotree close" }: that runs the Neotree user command
    -- inside vim.wait() and hangs :qa.
    close_filetypes_on_save = { "checkhealth", "neo-tree" },
    post_restore_cmds = { "Neotree show" },
  },
}
