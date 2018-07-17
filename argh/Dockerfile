FROM quay.io/dotmesh/jupyterlab-tensorflow:v2
COPY __init__.py /root/jupyterlab-plugin/jupyterlab_dotscience_backend/jupyterlab_dotscience_backend/__init__.py
RUN cd /root/jupyterlab-plugin/jupyterlab_dotscience_backend/jupyterlab_dotscience_backend && \
    rm -rf __pycache__
