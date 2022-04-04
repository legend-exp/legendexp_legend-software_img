FROM legendexp/legend-base:latest

# Note: use
#
# DOCKER_BUILDKIT=1 docker build --ssh default -t legendexp/legend-software:latest .
#
# to build.


# Install LEGEND Julia tutorial:

COPY provisioning/install-sw-scripts/juliatutorial-* provisioning/install-sw-scripts/

RUN provisioning/install-sw.sh juliatutorial legend-exp/4fb9cc2 /opt/legend-julia-tutorial


# Install LEGEND Python packages:

COPY \
    provisioning/install-sw-scripts/pygama-* \
    provisioning/install-sw-scripts/pyfcutils-* \
    provisioning/install-sw-scripts/

ENV PYTHONPATH="/opt/legend-python/lib/python3.8/site-packages:$PYTHONPATH"

RUN true \
    && provisioning/install-sw.sh pygama legend-exp/v0.9.0 /opt/legend-python \
    && provisioning/install-sw.sh pyfcutils legend-exp/52e5225 /opt/legend-python


# Install g4simple:

COPY provisioning/install-sw-scripts/g4simple-* provisioning/install-sw-scripts/

ENV PATH="/opt/g4simple/bin:$PATH"

RUN provisioning/install-sw.sh g4simple legend-exp/59a89c7 /opt/g4simple


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

RUN true \
    && yum install -y \
        xorg-x11-fonts-100dpi xorg-x11-fonts-75dpi \
        xorg-x11-fonts-ISO8859-1-100dpi xorg-x11-fonts-ISO8859-1-75dpi \
        xorg-x11-fonts-Type1 xorg-x11-fonts-misc \
    && provisioning/install-sw.sh radware radforddc/7844686 /opt/rw05


# Add GitHub SSH host key

RUN true \
    && mkdir .ssh \
    && ssh-keyscan -t rsa github.com > ~/.ssh/known_hosts


# Install MGDO and MaGe

COPY provisioning/install-sw-scripts/mage-* provisioning/install-sw-scripts/

ENV \
    PATH="/opt/mage/bin:$PATH" \
    LD_LIBRARY_PATH="/opt/mage/lib:$LD_LIBRARY_PATH" \
    MAGEDIR="/opt/mage" \
    MGGENERATORDATA="/opt/mage/share/MaGe/generators" \
    MGGERDAGEOMETRY="/opt/mage/share/MaGe/gerdageometry" \
    ROOT_INCLUDE_PATH="/opt/mage/include/mgdo:/opt/mage/include/tam:/opt/mage/include/mage:/opt/mage/include/mage-post-proc:$ROOT_INCLUDE_PATH"

RUN --mount=type=ssh provisioning/install-sw.sh mage legend-exp/89f6e26 /opt/mage
