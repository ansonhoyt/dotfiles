# Login shell configuration
#
# Bash looks for these in order, and runs the first available of:
#   .bash_profile, .bash_login, .profile
# - https://www.gnu.org/software/bash/manual/bashref.html#Bash-Startup-Files

# Also apply the interactive shell config:
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
