FROM quay.io/dotmesh/jupyterlab-tensorflow:v2
COPY __init__.py /root/jupyterlab-plugin/jupyterlab_dotscience_backend/jupyterlab_dotscience_backend/__init__.py
RUN cd /root/jupyterlab-plugin/jupyterlab_dotscience_backend/jupyterlab_dotscience_backend && \
    rm -rf __pycache__
RUN echo "c.NotebookApp.tornado_settings = {" >> /home/jovyan/.jupyter/jupyter_notebook_config.py && \
	echo "    'headers': {" >> /home/jovyan/.jupyter/jupyter_notebook_config.py && \
	echo "        'Content-Security-Policy': \"frame-ancestors 'self' *\"" >> /home/jovyan/.jupyter/jupyter_notebook_config.py && \
	echo "    }" >> /home/jovyan/.jupyter/jupyter_notebook_config.py && \
	echo "}" >> /home/jovyan/.jupyter/jupyter_notebook_config.py
