# Default editor (git, etc.)
export EDITOR=vim

# Ansible uses cowsay too much for my taste.
export ANSIBLE_NOCOWS=1

# gdal2 commands, per `brew info osgeo/osgeo4mac/gdal2`
export PATH="$(brew --prefix)/opt/gdal2/bin:$PATH"

# gdal2-python, per  `brew info osgeo/osgeo4mac/gdal2-python`
# export PATH="$(brew --prefix)/opt/gdal2-python/bin:$PATH"
