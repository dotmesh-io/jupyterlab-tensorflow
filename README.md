# jupyterlab-tensorflow

jupyterlab with tensorflow and the dotmesh jupyterlab extension

If any code inside of our [jupyterlab-plugin](https://github.com/dotmesh-io/jupyterlab-plugin) repo changes (server or browser extension) - one must:

```bash
git clone https://github.com/dotmesh-io/jupyterlab-tensorflow
cd jupyterlab-tensorflow
docker build -t quay.io/dotmesh/jupyterlab-tensorflow:v4 .
docker push quay.io/dotmesh/jupyterlab-tensorflow:v4
```
