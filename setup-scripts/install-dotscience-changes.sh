#!/bin/bash
set -euo pipefail

apt-get update && apt-get install -y --no-install-recommends curl

# Node
curl -sL https://deb.nodesource.com/setup_10.x |bash
apt-get update && apt-get install -y --no-install-recommends nodejs

# skipping --no-install-recommends for git in order to try and get ssh client
# and anything else that git relies on...
apt-get install -y git
node -v

# Hive and airflow bits
apt-get update
apt-get install -y libsasl2-dev
# Due to bug in jupyter-http-over-ws packaging, enum34 is being installed when
# the wheel is used, which breaks other stuff
# (https://github.com/googlecolab/jupyter_http_over_ws/issues/16). So, get rid
# of enum34 if it's here (comes from the base image I think).
python3 -m pip uninstall -y enum34 || true
python3 -m pip install pyhive[hive] apache-airflow

# Data science stuff
apt-get install -y --no-install-recommends libsm6 libxrender-dev libxext6 unzip wget
python3 -m pip install -r requirements.txt

jupyter serverextension enable --py jupyterlab_dotscience_backend --sys-prefix

## install and activate the browser extension
npm install
cd node_modules/@dotscience/jupyterlab-plugin && jupyter labextension install . --dev-build=False

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
apt-get remove -y nodejs
apt autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*
