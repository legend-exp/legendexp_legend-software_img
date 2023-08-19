FROM legendexp/legend-base:latest

# Note: use
#
# DOCKER_BUILDKIT=1 docker build --ssh default -t legendexp/legend-software:latest .
#
# to build.


# Install LEGEND Julia tutorial:

COPY provisioning/install-sw-scripts/juliatutorial-* provisioning/install-sw-scripts/

RUN provisioning/install-sw.sh juliatutorial legend-exp/2568744 /opt/legend-julia-tutorial


# Install LEGEND Python packages:

COPY \
    provisioning/install-sw-scripts/pygama-* \
    provisioning/install-sw-scripts/pyfcutils-* \
    provisioning/install-sw-scripts/pylegendmeta-* \
    provisioning/install-sw-scripts/

ENV PYTHONPATH="/opt/legend-python/lib/python3.9/site-packages:$PYTHONPATH"

RUN true \
    && provisioning/install-sw.sh pygama legend-exp/v1.3.2 /opt/legend-python \
    && provisioning/install-sw.sh pyfcutils legend-exp/v0.2.3 /opt/legend-python \
    && provisioning/install-sw.sh pylegendmeta legend-exp/v0.7.13 /opt/legend-python


# Install g4simple:

COPY provisioning/install-sw-scripts/g4simple-* provisioning/install-sw-scripts/

ENV PATH="/opt/g4simple/bin:$PATH"

RUN provisioning/install-sw.sh g4simple legend-exp/f8fe621 /opt/g4simple


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


# Install MGDO, MaGe and mage-post-proc

COPY provisioning/install-sw-scripts/mgdo-* provisioning/install-sw-scripts/

ENV \
    PATH="/opt/mgdo/bin:$PATH" \
    LD_LIBRARY_PATH="/opt/mgdo/lib:$LD_LIBRARY_PATH" \
    ROOT_INCLUDE_PATH="/opt/mage/include/mgdo:/opt/mage/include/tam:$ROOT_INCLUDE_PATH"

RUN --mount=type=ssh provisioning/install-sw.sh mgdo mppmu/ab61169 /opt/mgdo

COPY provisioning/install-sw-scripts/mage-* provisioning/install-sw-scripts/

ENV \
    PATH="/opt/mage/bin:$PATH" \
    LD_LIBRARY_PATH="/opt/mage/lib:$LD_LIBRARY_PATH" \
    MAGEDIR="/opt/mage" \
    MGGENERATORDATA="/opt/mage/share/MaGe/generators" \
    MGGERDAGEOMETRY="/opt/mage/share/MaGe/gerdageometry" \
    ROOT_INCLUDE_PATH="/opt/mage/include/mage:$ROOT_INCLUDE_PATH"

RUN --mount=type=ssh provisioning/install-sw.sh mage mppmu/4332f07 /opt/mage

COPY provisioning/install-sw-scripts/mage-post-proc-* provisioning/install-sw-scripts/

ENV \
    PATH="/opt/mage-post-proc/bin:$PATH" \
    LD_LIBRARY_PATH="/opt/mage-post-proc/lib:$LD_LIBRARY_PATH" \
    ROOT_INCLUDE_PATH="/opt/mage-post-proc/include/mage-post-proc:$ROOT_INCLUDE_PATH"

RUN --mount=type=ssh provisioning/install-sw.sh mage-post-proc legend-exp/3ec9fb8 /opt/mage-post-proc
