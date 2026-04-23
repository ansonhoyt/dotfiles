return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    -- Install parsers not bundled with Neovim (c, lua, markdown, query, vim, vimdoc are built-in)
    require('nvim-treesitter').install {
      'bash', 'css', 'embedded_template', 'hcl', 'html', 'javascript',
      'json', 'python', 'ruby', 'scss', 'terraform', 'toml', 'typescript', 'yaml',
    }

    -- Enable treesitter highlighting + indentation for all filetypes with a parser
    vim.api.nvim_create_autocmd('FileType', {
      callback = function()
        if pcall(vim.treesitter.start) then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end
}
