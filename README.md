# LEGEND Software Stack Linux Container Image

This repository contains the files necessary to generate a container image "legendexp/legend-software" that contains the open-source LEGEND software stack. The image is based on [`legendexp/legend-base:latest`](https://github.com/legend-exp/legendexp_legend-base_img/).

In addition to `legendexp/legend-base`, the open-source software stack contains:

* [pygama](https://github.com/legend-exp/pygama)
* [g4simple](https://github.com/legend-exp/g4simple)
* [gears](https://github.com/jintonic/gears)
* [radware rw05](https://github.com/radforddc/rw05)
* The Julia packages required by the [LEGEND Julia tutorial](https://github.com/legend-exp/legend-julia-tutorial), plus some additional Julia packages

Also, binaries of the following closed-source software are included:

* [MGDO](https://github.com/mppmu/MGDO)
* [MaGe](https://github.com/mppmu/MaGe)

Builds of this image are [available on Dockerhub](https://hub.docker.com/r/legendexp/legend-software/).

See [`legendexp/legend-base`](https://github.com/legend-exp/legendexp_legend-base_img) for container usage instructions (substitute `legendexp/legend-software` for `legendexp/legend-base`).
