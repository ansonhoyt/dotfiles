# Bash prompt
#
# Reference:
# \w working directory
# \u user
# \$ shows $ for normal user and # for root user

# Git Prompt
#-----------------
# $(__git_ps1) safely gets current git branch. See git-prompt.sh referenced from completions.sh.

# unstaged (*) and staged (+) changes will be shown next to the branch name
GIT_PS1_SHOWDIRTYSTATE=yes

# If something is stashed, then a '$' will be shown next to the branch name.
GIT_PS1_SHOWSTASHSTATE=yes

# Show difference between HEAD and its upstream
GIT_PS1_SHOWUPSTREAM="auto"

# Show colored hint about the current dirty state
GIT_PS1_SHOWCOLORHINTS=yes

#-----------------

export PS1='\[\033[0;32m\]\w$(__git_ps1 " (%s)") \$ \[\033[0m\['
