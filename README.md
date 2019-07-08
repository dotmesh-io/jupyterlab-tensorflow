# jupyterlab-tensorflow

jupyterlab with tensorflow and the dotmesh jupyterlab extension

This is now fully integrated into CI, so any changes here will get pushed and tested via e2e tests. Be aware though that we don't yet have frontend tests, so you should still manually check everything is ok.

## Releasing
After building this pipeline we trigger e2e tests via curl. As we release two images (CPU and GPU), there are two pipelines triggered. The latter (GPU) presently has no effect on the tests - the tests will run `test-latest` (at the time of writing) of the CPU image. This is because we don't have GPU runners and therefore there's no point configuring it to run GPU, but have a unified release process from this repo and didn't want to deviate from that.

TL;DR this repo triggers 2 e2e pipelines, the GPU one the tests are there for decoration and to force e2e tests to release that image but actually run against `jupyterlab-tensorflow:test-latest`.