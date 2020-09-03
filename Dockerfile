FROM legendexp/legend-base:latest

# Install LEGNED Julia tutorial:

COPY provisioning/install-sw-scripts/juliatutorial-* provisioning/install-sw-scripts/

RUN provisioning/install-sw.sh juliatutorial legend-exp/d42c2fd /opt/legend-julia-tutorial

ENV JULIA_PROJECT="/opt/julia/local/share/julia/environments/v1.5"


# Install pygama:

COPY provisioning/install-sw-scripts/pygama-* provisioning/install-sw-scripts/

ENV PYTHONPATH="/opt/pygama/lib/python3.7/site-packages:$PYTHONPATH"

RUN provisioning/install-sw.sh pygama legend-exp/v0.1-Nov2019 /opt/pygama


# Install g4simple:

COPY provisioning/install-sw-scripts/g4simple-* provisioning/install-sw-scripts/

ENV PATH="/opt/g4simple/bin:$PATH"

RUN provisioning/install-sw.sh g4simple legend-exp/077ed43 /opt/g4simple


# Install gears:

COPY provisioning/install-sw-scripts/gears-* provisioning/install-sw-scripts/

ENV PATH="/opt/gears/bin:$PATH"

RUN provisioning/install-sw.sh gears jintonic/0da27a8 /opt/gears
