
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"

# https://mise.jdx.dev/installing-mise.html#bash
eval "$(mise activate bash)"

# https://github.com/ajeetdsouza/zoxide
eval "$(zoxide init bash)"

# https://starship.rs/
eval "$(starship init bash)"
