FROM legendexp/legend-base:latest

# Note: use
#
# DOCKER_BUILDKIT=1 docker build --ssh default -t legendexp/legend-software:latest .
#
# to build.


# Install LEGEND Julia tutorial and additional Julia packages:

COPY provisioning/install-sw-scripts/juliatutorial-* provisioning/install-sw-scripts/

ENV \
    JULIA_CPU_TARGET="generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1);x86-64-v4,-rdrnd,base(1)" \
    JULIA_PKG_PRESERVE_TIERED_INSTALLED="true"

RUN provisioning/install-sw.sh juliatutorial legend-exp/10d44c8 /opt/legend-julia-tutorial


# Install LEGEND Python packages:

COPY \
    provisioning/install-sw-scripts/pygama-* \
    provisioning/install-sw-scripts/pyfcutils-* \
    provisioning/install-sw-scripts/pylegendmeta-* \
    provisioning/install-sw-scripts/

ENV PYTHONPATH="/opt/legend-python/lib/python3.9/site-packages:$PYTHONPATH"

RUN true \
    && pip3 install bottleneck==1.3.6 \
    && provisioning/install-sw.sh pygama legend-exp/v2.0.2 /opt/legend-python \
    && provisioning/install-sw.sh pyfcutils legend-exp/v0.2.4 /opt/legend-python \
    && provisioning/install-sw.sh pylegendmeta legend-exp/v1.0.0 /opt/legend-python


# Install g4simple:

COPY provisioning/install-sw-scripts/g4simple-* provisioning/install-sw-scripts/

ENV PATH="/opt/g4simple/bin:$PATH"

RUN provisioning/install-sw.sh g4simple legend-exp/8613eb5 /opt/g4simple


# Install gears:

COPY provisioning/install-sw-scripts/gears-* provisioning/install-sw-scripts/

ENV PATH="/opt/gears/bin:$PATH"

RUN provisioning/install-sw.sh gears jintonic/8ab0f37 /opt/gears


# Install radware:

COPY provisioning/install-sw-scripts/radware-* provisioning/install-sw-scripts/

ENV \
    PATH="/opt/rw05/bin:$PATH" \
    \
    RADWARE_HOME="/opt/rw05" \
    RADWARE_FONT_LOC="/opt/rw05/font" \
    RADWARE_ICC_LOC="/opt/rw05/icc" \
    RADWARE_GFONLINE_LOC="/opt/rw05/doc"

RUN provisioning/install-sw.sh radware radforddc/7844686 /opt/rw05


# Add GitHub SSH host key

RUN true \
    && mkdir .ssh \
    && ssh-keyscan -t rsa github.com > ~/.ssh/known_hosts


# Install MGDO

COPY provisioning/install-sw-scripts/mgdo-* provisioning/install-sw-scripts/

ENV \
    PATH="/opt/mgdo/bin:$PATH" \
    LD_LIBRARY_PATH="/opt/mgdo/lib:$LD_LIBRARY_PATH" \
    ROOT_INCLUDE_PATH="/opt/mage/include/mgdo:/opt/mage/include/tam:$ROOT_INCLUDE_PATH"

RUN --mount=type=ssh provisioning/install-sw.sh mgdo mppmu/d7b860b /opt/mgdo


# Install MaGe

COPY provisioning/install-sw-scripts/mage-* provisioning/install-sw-scripts/

ENV \
    PATH="/opt/mage/bin:$PATH" \
    LD_LIBRARY_PATH="/opt/mage/lib:$LD_LIBRARY_PATH" \
    MAGEDIR="/opt/mage" \
    MGGENERATORDATA="/opt/mage/share/MaGe/generators" \
    MGGERDAGEOMETRY="/opt/mage/share/MaGe/gerdageometry" \
    ROOT_INCLUDE_PATH="/opt/mage/include/mage:$ROOT_INCLUDE_PATH"

RUN --mount=type=ssh provisioning/install-sw.sh mage mppmu/aa4ad59 /opt/mage


# Install mage-post-proc

COPY provisioning/install-sw-scripts/mage-post-proc-* provisioning/install-sw-scripts/

ENV \
    PATH="/opt/mage-post-proc/bin:$PATH" \
    LD_LIBRARY_PATH="/opt/mage-post-proc/lib:$LD_LIBRARY_PATH" \
    ROOT_INCLUDE_PATH="/opt/mage-post-proc/include/mage-post-proc:$ROOT_INCLUDE_PATH"

RUN --mount=type=ssh provisioning/install-sw.sh mage-post-proc legend-exp/7076f8f /opt/mage-post-proc
