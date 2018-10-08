#!/bin/bash
set -xe

# expects git clone https://github.com/dotmesh-io/jupyterlab-plugin /root/jupyterlab-plugin
# in dev mode - we have mounted the jupyterlab-plugin repo to /root/jupyterlab-plugin
source activate base
jupyter lab --ip 0.0.0.0 --port 8888 --allow-root --notebook-dir /home/jovyan