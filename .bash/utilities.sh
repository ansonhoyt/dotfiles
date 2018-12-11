# Copy public key to remote host
# Usage: authorize server.example.com
function authorize () {
  ssh-copy-id -i ~/.ssh/id_rsa.pub $@
}
