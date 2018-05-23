FROM eddify/jupyterlab-tensorflow:latest
RUN conda install git pip nodejs -y
RUN git clone https://github.com/dotmesh-io/jupyterlab-plugin /root/jupyterlab-plugin

## install and activate the server extension
RUN source activate jupyterlab && \
  pip install datadots-api==0.1.2 && \
  (cd /root/jupyterlab-plugin && pip install -e jupyterlab_dotscience_backend) \
  && jupyter serverextension enable --py jupyterlab_dotscience_backend --sys-prefix

## install and activate the browser extension
RUN source activate jupyterlab && \
  cd /root/jupyterlab-plugin/jupyterlab_dotscience && \
  npm install && \
  npm run build && \
  jupyter labextension install .

## override the entrypoint to allow root
CMD /bin/bash -c "source activate jupyterlab && jupyter lab --ip 0.0.0.0 --port 8888 --allow-root --notebook-dir /home/jupyterlab"