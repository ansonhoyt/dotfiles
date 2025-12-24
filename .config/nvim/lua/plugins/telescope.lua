-- Telescope: navigate and search files
--
-- Consider lazy loading: https://typecraft.dev/tutorial/telescope-and-dotfiles
return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<C-p>', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
    end
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").setup {
        pickers = {
          find_files = {
            find_command = {
              "rg", "--files",
              "--hidden", "--glob=!.git/", "--glob=!tmp/"
            }
          },
          live_grep = {
            vimgrep_arguments = {
              "rg",
              "--color=never",
              "--smart-case",
              "--no-heading", "--with-filename", "--line-number", "--column",
              "--hidden", "--glob=!.git/", "--glob=!tmp/",
            }
          }
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown { }
          }
        }
      }
      require("telescope").load_extension("ui-select")
    end
  }
}

