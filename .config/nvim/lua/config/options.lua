-- Neovim options and settings
-- See :help vim.opt

-- Disable netrw (neo-tree replaces it; prevents E95 buffer conflict on `nvim .`)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.colorcolumn = "80,120"

-- UI improvements
vim.opt.cursorline = true     -- Highlight current line
vim.opt.signcolumn = "yes"    -- Always show sign column (prevents text shifting)
vim.opt.updatetime = 250      -- Faster LSP/plugin updates (default 4000ms)
vim.opt.cmdheight = 0         -- Hide command line when not in use
-- cmdheight=0 has no row for messages, so long/multiline ones escalate to a
-- blocking hit-enter prompt. In a backgrounded instance that prompt never gets
-- answered -> main loop parks in wait_return while timers keep allocating ->
-- unbounded LuaJIT heap growth (multi-GB). Drop hit-enter for a brief,
-- dismissible pause; history:500 keeps everything readable via :messages.
vim.opt.messagesopt = "wait:1500,history:500"
vim.opt.showmode = false      -- Mode already shown in lualine

-- Folding: treesitter by default; LspAttach upgrades to LSP folds when supported
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldtext = "v:lua.vim.lsp.foldtext()"
vim.o.foldlevelstart = 99     -- Start with all folds open

-- Session restore (auto-session)
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

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
