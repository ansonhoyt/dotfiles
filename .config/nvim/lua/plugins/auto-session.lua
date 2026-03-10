return {
  "rmagatti/auto-session",
  lazy = false,
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    suppressed_dirs = { "~/", "~/Downloads", "/tmp" },
    pre_save_cmds = { "Neotree close" },
    post_restore_cmds = { "Neotree show" },
  },
}
