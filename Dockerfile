# TensorFlow image has GPU support and Jupyter
FROM tensorflow/tensorflow:latest-py3

# Be root for some reason.
#USER root

# Try to do everything via conda
#RUN bash -c 'source activate base && conda install git pip nodejs -y'

# Install JupyterLab
#RUN bash -c 'source activate base && pip install jupyterlab'
#RUN bash -c 'source activate base && jupyter serverextension enable --py jupyterlab'

# Install Python library for Data Science
#RUN bash -c 'source activate base && pip --no-cache-dir install \
#        plotly \
#        Pillow \
#        google-api-python-client'

# Set up Jupyter Notebook config
#ENV CONFIG /home/jovyan/.jupyter/jupyter_notebook_config.py
#ENV CONFIG_IPYTHON /home/jovyan/.ipython/profile_default/ipython_config.py

#RUN bash -c 'source activate base && rm /home/jovyan/.jupyter/jupyter_notebook_config.py && jupyter notebook --generate-config --allow-root && \
#    ipython profile create'

#RUN echo "c.NotebookApp.ip = '*'" >>${CONFIG} && \
#    echo "c.NotebookApp.open_browser = False" >>${CONFIG} && \
#    echo "c.NotebookApp.iopub_data_rate_limit=10000000000" >>${CONFIG} && \
#    echo "c.MultiKernelManager.default_kernel_name = 'python3'" >>${CONFIG}

#RUN echo "c.InteractiveShellApp.exec_lines = ['%matplotlib inline']" >>${CONFIG_IPYTHON}

# ==== OUR STUFF FOLLOWS ====
ENV last-update "2018-12-17 11:14"

# Node
RUN curl -sL https://deb.nodesource.com/setup_8.x |bash
RUN apt-get update && apt-get install -y git nodejs

# Data science stuff
RUN apt-get install -y libsm6 libxrender-dev libxext6
RUN pip install opencv-python scikit-image

# JupyterLab (on top of a jupyter-only base)
RUN pip install jupyterlab

# Our Jupyter plugin
RUN mkdir -p /plugin && git clone https://github.com/dotmesh-io/jupyterlab-plugin /plugin/jupyterlab-plugin

ADD ./scripts /scripts

## install and activate the server extension
RUN bash /scripts/install-server-extension.sh

## install the dotscience workload library

ARG dotscience_python_tag
RUN if [ "x$dotscience_python_tag" = "x" ] ; then pip install --upgrade dotscience ; else pip install --upgrade dotscience==$dotscience_python_tag ; fi

## install and activate the browser extension
RUN bash /scripts/install-browser-extension.sh

# Enable a more liberal Content-Security-Policy so that we can display Jupyter
# in an iframe.
RUN bash /scripts/update-content-security-policy.sh

# Clean up files which otherwise get copied into the workspace dot, at the
# expense of a few hundred meg.
RUN cd /root && rm -rf .cache .conda .config .npm work .yarn

## override the entrypoint to allow root
CMD /bin/bash /scripts/start-jupyter.sh
