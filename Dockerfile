# adapted from
# https://hub.docker.com/r/eddify/jupyterlab-tensorflow/~/dockerfile/
# https://gitlab.com/nvidia/cuda/blob/ubuntau16.04/9.1/base/Dockerfile
# https://gitlab.com/nvidia/cuda/blob/ubuntu16.04/9.1/runtime/Dockerfile
# https://gitlab.com/nvidia/cuda/blob/ubuntu16.04/9.1/runtime/cudnn7/Dockerfile
# https://github.com/tensorflow/tensorflow/blob/b43d0f3c98140edfebb8295ea4a4b661e2fc2a85/tensorflow/tools/docker/Dockerfile.gpu
# https://github.com/conda/conda-docker/blob/master/miniconda3/debian/Dockerfile

FROM ubuntu:16.04
MAINTAINER Eddy Kim <eddykim87@gmail.com>
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        pkg-config \
        python \
        python-dev \
        rsync \
        software-properties-common \
        unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get -qq -y install curl bzip2 \
    && curl -sSL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -bfp /usr/local \
    && rm -rf /tmp/miniconda.sh \
    && conda install -y python=3 \
    && conda update conda
RUN conda create -n jupyterlab python=3 -y \
    && conda install -c condaforge jupyterlab -n jupyterlab \
    && source activate jupyterlab \
    && pip --no-cache-dir install \
        Pillow \
        h5py \
        matplotlib \
        numpy \
        pandas \
        scipy \
        sklearn \
        https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.5.0-cp36-cp36m-linux_x86_64.whl \
    && apt-get -qq -y remove curl bzip2 \
    && apt-get -qq -y autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log \
    && conda clean --all --yes \
    && useradd -m jupyterlab

ENV PATH /opt/conda/bin:$PATH
WORKDIR /home/jupyterlab

EXPOSE 8888

RUN conda install git pip nodejs -y
RUN git clone https://github.com/dotmesh-io/jupyterlab-plugin /root/jupyterlab-plugin

## install and activate the server extension
RUN source activate jupyterlab && \
  pip install datadots-api==0.1.4 && \
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
