FROM quay.io/dotmesh/jupyterlab-tensorflow:v2
COPY __init__.py /root/jupyterlab-plugin/jupyterlab_dotscience_backend/jupyterlab_dotscience_backend/__init__.py
RUN cd /root/jupyterlab-plugin/jupyterlab_dotscience_backend/jupyterlab_dotscience_backend && \
    rm -rf __pycache__
RUN echo "c.NotebookApp.tornado_settings = {" >> /etc/jupyter/jupyter_notebook_config.py && \
	echo "    'headers': {" >> /etc/jupyter/jupyter_notebook_config.py && \
	echo "        'Content-Security-Policy': \"frame-ancestors 'self' *\"" >> /etc/jupyter/jupyter_notebook_config.py && \
	echo "    }" >> /etc/jupyter/jupyter_notebook_config.py && \
	echo "}" >> /etc/jupyter/jupyter_notebook_config.py
RUN cd /home/jovyan && rm -rf .cache .conda .config .npm work .yarn
