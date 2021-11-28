FROM legendexp/legend-base:latest

# Install LEGEND Julia tutorial:

COPY provisioning/install-sw-scripts/juliatutorial-* provisioning/install-sw-scripts/

RUN provisioning/install-sw.sh juliatutorial legend-exp/de15108 /opt/legend-julia-tutorial


# Install LEGEND Python packages:

COPY \
    provisioning/install-sw-scripts/pygama-* \
    provisioning/install-sw-scripts/pyfcutils-* \
    provisioning/install-sw-scripts/

ENV PYTHONPATH="/opt/legend-python/lib/python3.8/site-packages:$PYTHONPATH"

RUN true \
    && provisioning/install-sw.sh pygama legend-exp/v0.8 /opt/legend-python \
    && provisioning/install-sw.sh pyfcutils legend-exp/52e5225 /opt/legend-python


# Install g4simple:

COPY provisioning/install-sw-scripts/g4simple-* provisioning/install-sw-scripts/

ENV PATH="/opt/g4simple/bin:$PATH"

RUN provisioning/install-sw.sh g4simple legend-exp/ebdbfcb /opt/g4simple


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
    && provisioning/install-sw.sh radware radforddc/fc7549f /opt/rw05
