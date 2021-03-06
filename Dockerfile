FROM legendexp/legend-base:latest

# Install LEGEND Julia tutorial:

COPY provisioning/install-sw-scripts/juliatutorial-* provisioning/install-sw-scripts/

RUN provisioning/install-sw.sh juliatutorial legend-exp/b3d91e6 /opt/legend-julia-tutorial


# Install LEGEND Python packages:

COPY \
    provisioning/install-sw-scripts/pygama-* \
    provisioning/install-sw-scripts/pyfcutils-* \
    provisioning/install-sw-scripts/

ENV PYTHONPATH="/opt/legend-python/lib/python3.8/site-packages:$PYTHONPATH"

RUN true \
    && provisioning/install-sw.sh pygama legend-exp/v0.4 /opt/legend-python \
    && provisioning/install-sw.sh pyfcutils legend-exp/52e5225 /opt/legend-python


# Install g4simple:

COPY provisioning/install-sw-scripts/g4simple-* provisioning/install-sw-scripts/

ENV PATH="/opt/g4simple/bin:$PATH"

RUN provisioning/install-sw.sh g4simple legend-exp/a5e8ae0 /opt/g4simple


# Install gears:

COPY provisioning/install-sw-scripts/gears-* provisioning/install-sw-scripts/

ENV PATH="/opt/gears/bin:$PATH"

RUN provisioning/install-sw.sh gears jintonic/bbdbde2 /opt/gears
