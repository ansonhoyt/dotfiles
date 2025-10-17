# Copy SSH public key to a remote host
function authorize () {
  if [ $# -eq 0 ]; then
    echo "Usage: authorize server.example.com"
  else
    ssh-copy-id -i ~/.ssh/id_rsa.pub $@
  fi
}

# List processes listening to TCP ports (or the given port)
# https://stackoverflow.com/questions/4421633/who-is-listening-on-a-given-tcp-port-on-mac-os-x
listening() {
    if [ $# -eq 0 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P
    elif [ $# -eq 1 ]; then
        sudo lsof -i:$1 -sTCP:LISTEN -n -P
    else
        echo "Usage: listening [pattern]"
    fi
}
