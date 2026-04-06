# Use Bash Completions
#
# See `brew info bash-completion@2` and https://docs.brew.sh/Shell-Completion

if [[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]]; then
  source "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
else
  echo "run: brew install bash-completion@2"
fi

eval "$(register-python-argcomplete pipx)"

# Fuzzy-complete AWS CLI via fzf: aws ec2 **<TAB>
# Overrides `complete -C` with `-F` so fzf's ** trigger works.
# Normal TAB still completes as usual.
_aws_fzf_completion() {
  local cur="${COMP_WORDS[COMP_CWORD]}"

  if [[ "$cur" == *'**' ]]; then
    # Build clean line for aws_completer (without **), but don't
    # modify COMP_WORDS — _fzf_complete needs to see the ** trigger
    local words=("${COMP_WORDS[@]}")
    words[COMP_CWORD]="${cur%%\*\*}"
    local line="${words[*]}"
    _fzf_complete -- "$@" < <(
      COMP_LINE="$line " COMP_POINT=$(( ${#line} + 1 )) aws_completer
    )
  else
    local comp_line="${COMP_WORDS[*]}"
    COMPREPLY=($(
      COMP_LINE="$comp_line" COMP_POINT=${#comp_line} aws_completer
    ))
  fi
}
complete -F _aws_fzf_completion aws
