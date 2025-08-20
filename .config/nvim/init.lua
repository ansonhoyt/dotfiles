vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set shiftwidth=2")

vim.cmd("set number")
vim.g.mapleader = " "

require("config.lazy")
vim.lsp.enable("ruby-lsp")
