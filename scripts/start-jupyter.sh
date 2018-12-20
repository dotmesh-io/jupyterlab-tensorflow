#!/bin/bash
set -xe

# make sure we use the -w flag passed to docker run as where to load the notebooks
# from - this will be the same place as the workspace dot is mounted
export NOTEBOOK_DIR=${NOTEBOOK_DIR:="$PWD"}

# expects git clone https://github.com/dotmesh-io/jupyterlab-plugin /plugin/jupyterlab-plugin
# in dev mode - we have mounted the jupyterlab-plugin repo to /plugin/jupyterlab-plugin
#source activate base
jupyter lab --ip 0.0.0.0 --port 8888 --allow-root --notebook-dir "$NOTEBOOK_DIR"
