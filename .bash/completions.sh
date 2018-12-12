# Activate Bash Completions
#
# Loads the named completions from `brew --prefix`/etc/bash_completion.d
#
# == Note
#
# Homebrew seems to be installing them in `/usr/local/etc/bash_completion.d/`
# so we'll roll with that, despite many posts and packages with different instructions.
#
# Lots of conflicting instructions for setting these up:
# https://debian-administration.org/article/316/An_introduction_to_bash_completion_part_1
# https://github.com/scop/bash-completion (via `brew info bash-completion`)

# Update array from: ls -1 `brew --prefix`/etc/bash_completion.d
declare -a completions=(brew
                        # brew-services
                        bundler
                        docker
                        gem
                        # gibo-completion.bash
                        git-completion.bash
                        git-prompt.sh
                        mas
                        npm
                        rails
                        rake
                        rg.bash
                        ruby
                        tmux
                        yarn)
start=$(gdate +%s%3N)

echo -n "(Bash completions:"
for pkg in "${completions[@]}"
do
  if [ -f `brew --prefix`/etc/bash_completion.d/$pkg ]; then
    echo -n " $pkg"
    . `brew --prefix`/etc/bash_completion.d/$pkg
  else
    echo "Missing bash completions for $pkg"
  fi
done

end=$(gdate +%s%3N)

echo ") in $[$end - $start]ms"
