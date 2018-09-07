# TensorFlow & scikit-learn with Python3
FROM jupyter/tensorflow-notebook:137a295ff71b

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

# Enable a more liberal Content-Security-Policy so that we can display Jupyter
# in an iframe.
RUN echo "c.NotebookApp.tornado_settings = {" >> /etc/jupyter/jupyter_notebook_config.py && \
       echo "    'headers': {" >> /etc/jupyter/jupyter_notebook_config.py && \
       echo "        'Content-Security-Policy': \"frame-ancestors 'self' *\"" >> /etc/jupyter/jupyter_notebook_config.py && \
       echo "    }" >> /etc/jupyter/jupyter_notebook_config.py && \
       echo "}" >> /etc/jupyter/jupyter_notebook_config.py

ENV last-update "2018-09-07 21:55"
RUN git clone https://github.com/dotmesh-io/jupyterlab-plugin /root/jupyterlab-plugin

## install and activate the server extension
RUN bash -c 'source activate base && \
  pip install git+git://github.com/dotmesh-io/python-sdk@bb1ace821d13b496e01efe4d748aa76e648d841b#egg=datadots-api && \
  (cd /root/jupyterlab-plugin && pip install -e jupyterlab_dotscience_backend) \
  && jupyter serverextension enable --py jupyterlab_dotscience_backend --sys-prefix'

## install and activate the browser extension
RUN bash -c 'source activate base && \
  cd /root/jupyterlab-plugin/jupyterlab_dotscience && \
  npm install && \
  npm run build && \
  jupyter labextension install .'

#  echo ============================== && \
#  echo INSTALL WEBPACK && \
#  cd /root/jupyterlab-plugin/jupyterlab_dotscience && \
#  npm install --global webpack-cli webpack && \
#  echo ============================== && \

# Clean up files which otherwise get copied into the workspace dot, at the
# expense of a few hundred meg.
RUN cd /home/jovyan && rm -rf .cache .conda .config .npm work .yarn

## override the entrypoint to allow root
CMD /bin/bash -c "source activate base && jupyter lab --ip 0.0.0.0 --port 8888 --allow-root --notebook-dir /home/jovyan"
