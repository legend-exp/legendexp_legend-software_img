FROM legendexp/legend-base:latest

# Install Julia packages

COPY provisioning/data/julia/environment /opt/julia/local/share/julia/environments/v1.1

RUN true \
    && export JULIA_DEPOT_PATH="/opt/julia/local/share/julia" \
	&& export JUPYTER_DATA_DIR="/opt/anaconda3/share/jupyter" \
    && julia -e 'using Pkg; pkg"instantiate; precompile"'


# Install pygama:

COPY provisioning/install-sw-scripts/pygama-* provisioning/install-sw-scripts/

ENV PYTHONPATH="/opt/pygama/lib/python3.7/site-packages:$PYTHONPATH"

RUN provisioning/install-sw.sh pygama legend-exp/91c8f5d /opt/pygama


# Install g4simple:

COPY provisioning/install-sw-scripts/g4simple-* provisioning/install-sw-scripts/

ENV PATH="/opt/g4simple/bin:$PATH"

RUN provisioning/install-sw.sh g4simple legend-exp/e854866 /opt/g4simple


# Install gears:

COPY provisioning/install-sw-scripts/gears-* provisioning/install-sw-scripts/

ENV PATH="/opt/gears/bin:$PATH"

RUN provisioning/install-sw.sh gears jintonic/d44b23a /opt/gears
