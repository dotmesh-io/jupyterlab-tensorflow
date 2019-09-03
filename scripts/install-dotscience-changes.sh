#!/bin/bash
set -euo pipefail

apt-get install -y --no-install-recommends curl

# Node
curl -sL https://deb.nodesource.com/setup_8.x |bash
apt-get update && apt-get install -y --no-install-recommends git nodejs
node -v

# Data science stuff
apt-get install -y --no-install-recommends libsm6 libxrender-dev libxext6 unzip wget
pip install -r requirements.txt
jupyter serverextension enable --py jupyterlab_dotscience_backend --sys-prefix

## install and activate the browser extension
npm install
cd node_modules/@dotscience/jupyterlab-plugin && jupyter labextension install .

# for branch builds, replace the above with this and specify the branch in 'git
# checkout' below
#git clone https://github.com/dotmesh-io/jupyterlab-plugin && \
#    cd jupyterlab-plugin && \
#    git checkout frontend-ng-498-reverse-commits-hide-initial && \
#    cd jupyterlab_dotscience && \
#    npm install -g typescript && \
#    npm install -g . && \
#    tsc && \
#    jupyter labextension install . || (cat /tmp/jupyterlab-debug-*.log ; false)

# Enable a more liberal Content-Security-Policy so that we can display Jupyter
# in an iframe.
bash /scripts/update-content-security-policy.sh

# Autosave every second to avoid having to save after a run for Dotscience to
# trigger a run.
mkdir -p /usr/local/share/jupyter/lab/settings && echo '{"@jupyterlab/docmanager-extension:plugin":{"autosaveInterval": 1}}' > /usr/local/share/jupyter/lab/settings/overrides.json

# Clean up files which otherwise get copied into the workspace dot, at the
# expense of a few hundred meg.
cd /root && rm -rf .cache .conda .config .npm work .yarn
rm -rf /app/node_modules

# Uninstall apt packages and caches we no longer need:
apt-get remove -y libxrender-dev git nodejs curl wget unzip
apt autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*
