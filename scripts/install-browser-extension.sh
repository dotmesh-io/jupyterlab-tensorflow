#!/bin/bash
set -xe

# expects git clone https://github.com/dotmesh-io/jupyterlab-plugin /plugin/jupyterlab-plugin
# in dev mode - we have mounted the jupyterlab-plugin repo to /plugin/jupyterlab-plugin

#source activate base
cd /plugin/jupyterlab-plugin/jupyterlab_dotscience
npm install
npm run build

jupyter labextension install . --dev-build=False
