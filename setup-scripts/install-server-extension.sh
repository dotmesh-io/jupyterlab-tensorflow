#!/bin/bash
set -xe

# expects git clone https://github.com/dotmesh-io/jupyterlab-plugin /plugin/jupyterlab-plugin
# in dev mode - we need to mount the jupyterlab-plugin repo to /plugin/jupyterlab-plugin

#source activate base
pip install git+git://github.com/dotmesh-io/python-sdk@bb1ace821d13b496e01efe4d748aa76e648d841b#egg=datadots-api
(cd /plugin/jupyterlab-plugin && pip install -e jupyterlab_dotscience_backend)

jupyter serverextension enable --py jupyterlab_dotscience_backend --sys-prefix
