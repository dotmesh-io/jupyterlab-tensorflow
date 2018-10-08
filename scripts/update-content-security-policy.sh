#!/bin/bash
set -xe

# Enable a more liberal Content-Security-Policy so that we can display Jupyter
# in an iframe.

cat << EOF >> /etc/jupyter/jupyter_notebook_config.py
c.NotebookApp.tornado_settings = {
  'headers': {
    'Content-Security-Policy': "frame-ancestors 'self' *"
  }
}
EOF
