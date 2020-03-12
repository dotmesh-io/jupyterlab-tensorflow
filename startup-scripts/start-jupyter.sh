#!/bin/bash
set -xeuo pipefail

# make sure we use the -w flag passed to docker run as where to load the notebooks
# from - this will be the same place as the workspace dot is mounted
export NOTEBOOK_DIR=${NOTEBOOK_DIR:="$PWD"}
export USER_VENV="$NOTEBOOK_DIR/user-virtualenv"
if [ -f "$NOTEBOOK_DIR/requirements.txt" ]; then
    if [ ! -d "$USER_VENV" ]; then
        python3 -m virtualenv "$USER_VENV"
    fi

    /scripts/install-reqs.py
fi

export SHELL=bash

# If GATEWAY_URL_PREFIX is set, run with given URL prefix (see
# https://jupyter-notebook.readthedocs.io/en/stable/config.html for details);
# this enables reverse proxying to Jupyter from a path that is different than
# the normal Jupyter path:
if [ "${GATEWAY_URL_PREFIX:-}" != "" ]; then
    mkdir -p ~/.jupyter
    cat > ~/.jupyter/jupyter_notebook_config.py << EOF
c.NotebookApp.allow_remote_access = True
c.NotebookApp.base_url = "$GATEWAY_URL_PREFIX"
c.NotebookApp.iopub_data_rate_limit = 50000000
EOF
fi

# expects git clone https://github.com/dotmesh-io/jupyterlab-plugin /plugin/jupyterlab-plugin
# in dev mode - we have mounted the jupyterlab-plugin repo to /plugin/jupyterlab-plugin
#source activate base
exec jupyter lab --ip 0.0.0.0 --port 8888 --allow-root --notebook-dir "$NOTEBOOK_DIR"
