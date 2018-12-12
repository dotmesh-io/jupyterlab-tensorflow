# TensorFlow & scikit-learn with Python3
FROM jupyter/tensorflow-notebook:50d1eb9ec2d8

# Be root for some reason.
USER root

# Try to do everything via conda
RUN bash -c 'source activate base && conda install git pip nodejs -y'

# Install JupyterLab
RUN bash -c 'source activate base && pip install jupyterlab'
RUN bash -c 'source activate base && jupyter serverextension enable --py jupyterlab'

# Install Python library for Data Science
RUN bash -c 'source activate base && pip --no-cache-dir install \
        plotly \
        Pillow \
        google-api-python-client'

# Set up Jupyter Notebook config
ENV CONFIG /home/jovyan/.jupyter/jupyter_notebook_config.py
ENV CONFIG_IPYTHON /home/jovyan/.ipython/profile_default/ipython_config.py

RUN bash -c 'source activate base && rm /home/jovyan/.jupyter/jupyter_notebook_config.py && jupyter notebook --generate-config --allow-root && \
    ipython profile create'

RUN echo "c.NotebookApp.ip = '*'" >>${CONFIG} && \
    echo "c.NotebookApp.open_browser = False" >>${CONFIG} && \
    echo "c.NotebookApp.iopub_data_rate_limit=10000000000" >>${CONFIG} && \
    echo "c.MultiKernelManager.default_kernel_name = 'python3'" >>${CONFIG}

RUN echo "c.InteractiveShellApp.exec_lines = ['%matplotlib inline']" >>${CONFIG_IPYTHON}

# ==== OUR STUFF FOLLOWS ====

ENV last-update "2018-12-12 19:08"
RUN git clone https://github.com/dotmesh-io/jupyterlab-plugin /root/jupyterlab-plugin

ADD ./scripts /scripts

## install and activate the server extension
RUN bash /scripts/install-server-extension.sh

## install the dotscience workload library
## TODO: revert this to the pip package when ready
#RUN pip install dotscience
RUN pip install --upgrade git+git://github.com/dotmesh-io/dotscience-python

## install and activate the browser extension
RUN bash /scripts/install-browser-extension.sh

# Enable a more liberal Content-Security-Policy so that we can display Jupyter
# in an iframe.
RUN bash /scripts/update-content-security-policy.sh

# Clean up files which otherwise get copied into the workspace dot, at the
# expense of a few hundred meg.
RUN cd /home/jovyan && rm -rf .cache .conda .config .npm work .yarn

## override the entrypoint to allow root
CMD /bin/bash /scripts/start-jupyter.sh
