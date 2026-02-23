-- Neovim options and settings
-- See :help vim.opt

-- Editor behavior
vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.opt.tabstop = 2           -- Number of spaces tabs count for
vim.opt.shiftwidth = 2        -- Size of an indent

-- Indentation
vim.opt.smartindent = true    -- Auto-indent new lines
vim.opt.shiftround = true     -- Round indent to multiple of shiftwidth

-- Search
vim.opt.ignorecase = true     -- Case insensitive search
vim.opt.smartcase = true      -- But case-sensitive if uppercase in search

-- Display
vim.opt.number = true         -- Show line numbers
vim.opt.list = true           -- Show whitespace characters
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣", lead = "." }
vim.opt.colorcolumn = "80,120"

-- UI improvements
vim.opt.termguicolors = true  -- True color support (for catppuccin theme)
vim.opt.cursorline = true     -- Highlight current line
vim.opt.signcolumn = "yes"    -- Always show sign column (prevents text shifting)
vim.opt.updatetime = 250      -- Faster LSP/plugin updates (default 4000ms)

-- Files
vim.opt.undofile = true       -- Persistent undo history
vim.opt.backup = false        -- Don't create backup files

-- Mouse and clipboard integration
vim.opt.mouse = "a"           -- Enable mouse support in all modes
vim.opt.clipboard = "unnamedplus" -- Use system clipboard for yank/paste

-- Filetypes: treat JSONC-supporting files as jsonc
vim.filetype.add({
  pattern = {
    [".*%.gemini/settings%.json"] = "jsonc",
  },
})
