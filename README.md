# jupyterlab-tensorflow

jupyterlab with tensorflow and the dotmesh jupyterlab extension

based on [eddify/jupyterlab-tensorflow](https://github.com/eddify/jupyterlab-tensorflow)

If any code inside of our [jupyterlab-plugin](https://github.com/dotmesh-io/jupyterlab-plugin) repo changes (server or browser extension) - one must:

```bash
git clone https://github.com/dotmesh-io/jupyterlab-tensorflow
cd jupyterlab-tensorflow
docker build -t quay.io/dotmesh/jupyterlab-tensorflow:latest .
docker push quay.io/dotmesh/jupyterlab-tensorflow:latest
```
