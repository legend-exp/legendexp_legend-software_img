# LEGEND Software Stack Linux Container Image

This repository contains the files necessary to generate a container image "legendexp/legend-software" that contains the open-source LEGEND software stack. The image is based on [`legendexp/legend-base:latest`](https://github.com/legend-exp/legendexp_legend-base_img/).

In addition to `legendexp/legend-base`, the open-source software stack contains:

* pygama
* gears
* g4simple
* LEGEND-related julia packages

Builds of this image are [available on Dockerhub](https://hub.docker.com/r/legendexp/legend-software/).

See [`legendexp/legend-base`](https://github.com/legend-exp/legendexp_legend-base_img) for container usage instructions (substitute "legendexp/legend-software" for "legendexp/legend-base").
