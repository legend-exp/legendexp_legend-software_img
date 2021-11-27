# This software is licensed under the MIT "Expat" License.
#
# Copyright (c) 2017: Oliver Schulz.


DEFAULT_BUILD_OPTS=""


pkg_installed_check() {
    test -f "${INSTALL_PREFIX}/bin/sdgen"
}


pkg_install() {
    GITHUB_USER=`echo "${PACKAGE_VERSION}" | cut -d '/' -f 1`
    GIT_BRANCH=`echo "${PACKAGE_VERSION}" | cut -d '/' -f 2`
    git clone --recursive "https://github.com/${GITHUB_USER}/rw05" rw05
    (cd rw05 && git checkout "${GIT_BRANCH}")

    (
        cd rw05/src
        cp -a Makefile.linux Makefile
        make -j `nproc`

        mkdir -p "${INSTALL_PREFIX}/bin"
        for f in 4dg8r 4play addesc addmat algndiag calib_ascii combine divide dixie_gls doplot.sh drawstring effit encal energy escl8r foldout fwhm_cal gf3 gf3_nographics gf3x gls gls_conv incub8r legft levit8r lufwhm make4cub pedit plot plot2ps pro3d pro4d pslice sdgen slice spec_ascii split4cub statft subbgm2 subbgmat symmat txt2spe unfold unfoldesc unix2unix vms2unix win2tab; do
            /usr/bin/install -m 0755 "$f" "${INSTALL_PREFIX}/bin/"
        done
    )

    (
        cd rw05
        cp -a "demo" "doc" "font" "icc" "${INSTALL_PREFIX}/"
    )

    chmod go-w -R "${INSTALL_PREFIX}/"

    test -f "${INSTALL_PREFIX}/bin/sdgen"
}


pkg_env_vars() {
cat <<-EOF
PATH="${INSTALL_PREFIX}/bin:\$PATH"
RADWARE_HOME="${INSTALL_PREFIX}"
RADWARE_FONT_LOC="${INSTALL_PREFIX}/font"
RADWARE_ICC_LOC="${INSTALL_PREFIX}/icc"
RADWARE_GFONLINE_LOC="${INSTALL_PREFIX}/doc"
export PATH RADWARE_HOME RADWARE_FONT_LOC RADWARE_ICC_LOC RADWARE_GFONLINE_LOC
EOF
}
