# Apply interactive shell settings to this (login) shell
# See https://www.gnu.org/software/bash/manual/bashref.html#Bash-Startup-Files
#
# macOS checks for these in order: .bash_profile, .bash_login, .profile
# The first one found is run, not the rest.

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
