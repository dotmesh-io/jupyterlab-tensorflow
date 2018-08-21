#!/bin/bash
docker build -t quay.io/dotmesh/jupyterlab-tensorflow:hack-v7 .
docker push quay.io/dotmesh/jupyterlab-tensorflow:hack-v7

