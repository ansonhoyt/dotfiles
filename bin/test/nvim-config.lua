-- Exercise real config without loading plugins, starting servers, or the logger.
local case = arg[1]
local conform = dofile(".config/nvim/lua/plugins/conform.lua")

if case == "formatting" then
  conform.init()
  local first = vim.api.nvim_get_current_buf()
  local second = vim.api.nvim_create_buf(true, false)
  local function enabled(buf)
    return conform.opts.format_on_save(buf) ~= nil
  end

  assert(enabled(first) and enabled(second), "formatting should start enabled")
  vim.cmd("FormatDisable!")
  assert(not enabled(first) and enabled(second), "buffer disable affected another buffer")
  vim.cmd("FormatEnable")
  assert(not enabled(first), "global enable cleared a buffer-local disable")
  vim.cmd("FormatEnable!")
  assert(enabled(first), "buffer enable did not clear its disable")

  vim.cmd("FormatDisable")
  vim.cmd("FormatDisable!")
  vim.cmd("FormatEnable!")
  assert(vim.g.disable_autoformat == true, "buffer enable cleared global disable")
  assert(not enabled(first) and not enabled(second), "global disable was lost")
  vim.cmd("FormatEnable")
  assert(enabled(first) and enabled(second), "global enable did not restore formatting")
elseif case == "python" then
  assert(vim.deep_equal(conform.opts.formatters_by_ft.python, {
    "ruff_organize_imports", "ruff_format",
  }), "Python import organization must precede formatting")
elseif case == "lsp" then
  dofile(".config/nvim/lua/config/options.lua")
  local specs = dofile(".config/nvim/lua/plugins/lsp-config.lua")
  assert(specs[2].opts.automatic_enable == false, "Mason must not separately activate servers")

  -- Stub only external completion capabilities and server startup.
  package.loaded.cmp_nvim_lsp = { default_capabilities = function() return {} end }
  local enabled
  vim.lsp.enable = function(servers) enabled = servers end
  specs[4].config()
  assert(type(enabled) == "table", "native LSP activation was not called")
  for _, server in ipairs(specs[2].opts.ensure_installed) do
    assert(vim.tbl_contains(enabled, server), "installed server not enabled: " .. server)
  end

  vim.lsp.get_client_by_id = function()
    return { supports_method = function() return true end }
  end
  for _ = 1, 2 do
    assert(vim.wo.foldmethod == "expr", "fold method changed")
    assert(vim.wo.foldexpr == "v:lua.vim.treesitter.foldexpr()", "initial fold expression changed")
    assert(vim.wo.foldtext ~= "v:lua.vim.lsp.foldtext()", "LSP fold text remains enabled")
    vim.api.nvim_exec_autocmds("LspAttach", { buffer = 0, data = { client_id = 1 } })
    assert(vim.wo.foldexpr == "v:lua.vim.treesitter.foldexpr()", "LSP attachment replaced Tree-sitter folding")
    vim.cmd("vsplit")
  end
else
  error("unknown test case: " .. tostring(case))
end
