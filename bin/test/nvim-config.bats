#!/usr/bin/env bats

setup() {
  command -v nvim >/dev/null || skip "Neovim is not installed"
  cd "$BATS_TEST_DIRNAME/../.." || return
}

@test "Neovim format toggles preserve global and buffer scopes" {
  run nvim --headless -u NONE -i NONE -l "$BATS_TEST_DIRNAME/nvim-config.lua" formatting
  [ "$status" -eq 0 ]
}

@test "Neovim organizes Python imports before formatting" {
  run nvim --headless -u NONE -i NONE -l "$BATS_TEST_DIRNAME/nvim-config.lua" python
  [ "$status" -eq 0 ]
}

@test "Neovim native LSP activation preserves Tree-sitter folds" {
  # options.lua uses messagesopt, unavailable in older Neovim releases.
  nvim --headless -u NONE -i NONE '+lua vim.cmd.cquit(vim.fn.exists("+messagesopt") == 1 and 0 or 1)' || skip "Neovim lacks messagesopt"
  run nvim --headless -u NONE -i NONE -l "$BATS_TEST_DIRNAME/nvim-config.lua" lsp
  [ "$status" -eq 0 ]
}
