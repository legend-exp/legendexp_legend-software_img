# This software is licensed under the MIT "Expat" License.
#
# Copyright (c) 2022: Oliver Schulz.


DEFAULT_BUILD_OPTS=""


pkg_installed_check() {
    test -f "${INSTALL_PREFIX}/bin/MaGe"
}


pkg_install() {
    GITHUB_USER=`echo "${PACKAGE_VERSION}" | cut -d '/' -f 1`
    GIT_BRANCH=`echo "${PACKAGE_VERSION}" | cut -d '/' -f 2`
    git clone "https://github.com/${GITHUB_USER}/legend-swdev-scripts" legend-swdev-scripts

    source disable-conda.sh

    cd legend-swdev-scripts
    git checkout "${GIT_BRANCH}"

    BUILDPATH="magebuildpath"

    mkdir -p "$INSTALL_PREFIX"
    mkdir -p "$BUILDPATH"
    python3 installMaGe.py install \
        --jobs=`nproc` \
        --authentication="ssh" \
        --magebranch="main" \
        --buildpath="$BUILDPATH" \
        --installpath="$INSTALL_PREFIX" \
        && echo "MaGe installation successful"

    (
        cd "$INSTALL_PREFIX/lib"
        rm -f *.a
    )

    (
        cd "$INSTALL_PREFIX/include/mage"
        mkdir -p io mjio
        ln -s ../MGOutputG4StepsData.hh io/
        ln -s ../MJOutputSegXtal.hh mjio/
        ln -s ../MJOutputDetectorEventData.hh mjio/
    )

    (
        cd "$INSTALL_PREFIX"
        ln -s share/MaGe data

        # Remove non-public data:
        cd "share/MaGe"
        rm -rf gerdageometry legendgeometry mjgeometry
    )
}


pkg_env_vars() {
cat <<-EOF
PATH="${INSTALL_PREFIX}/bin:\$PATH"
LD_LIBRARY_PATH="${INSTALL_PREFIX}/lib:\$LD_LIBRARY_PATH"
MAGEDIR="${INSTALL_PREFIX}"
MGGENERATORDATA="$INSTALL_PREFIX/share/MaGe/generators"
MGGERDAGEOMETRY="$INSTALL_PREFIX/share/MaGe/gerdageometry"
ROOT_INCLUDE_PATH="$INSTALL_PREFIX/include/mgdo:$INSTALL_PREFIX/include/tam:$INSTALL_PREFIX/include/mage:$INSTALL_PREFIX/include/mage-post-proc:\$ROOT_INCLUDE_PATH"
export PATH LD_LIBRARY_PATH MGGENERATORDATA MGGERDAGEOMETRY ROOT_INCLUDE_PATH
EOF
}
