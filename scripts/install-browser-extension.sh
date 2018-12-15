#!/bin/bash
set -xe

# expects git clone https://github.com/dotmesh-io/jupyterlab-plugin /root/jupyterlab-plugin
# in dev mode - we have mounted the jupyterlab-plugin repo to /root/jupyterlab-plugin

#source activate base
cd /root/jupyterlab-plugin/jupyterlab_dotscience
npm install
npm run build

pip install jupyterlab

jupyter labextension install .
