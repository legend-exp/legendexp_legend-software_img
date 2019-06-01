# This software is licensed under the MIT "Expat" License.
#
# Copyright (c) 2017: Oliver Schulz.


DEFAULT_BUILD_OPTS=""


pkg_installed_check() {
    test -f "${INSTALL_PREFIX}/bin/g4simple"
}


pkg_install() {
    GITHUB_USER=`echo "${PACKAGE_VERSION}" | cut -d '/' -f 1`
    GIT_BRANCH=`echo "${PACKAGE_VERSION}" | cut -d '/' -f 2`
    git clone "https://github.com/${GITHUB_USER}/g4simple" g4simple

    hdf5_include_dir="$(dirname $(dirname $(command -v h5cc)))/include"
    export CPLUS_INCLUDE_PATH="${hdf5_include_dir}"

    cd g4simple
    git checkout "${GIT_BRANCH}"

    g4prefix=`geant4-config --prefix`
    g4version=`geant4-config --version`
    source "${g4prefix}/share/Geant4-${g4version}/geant4make/geant4make.sh"
    export G4WORKDIR="`pwd`/workdir"

    devtoolset=`rpm -qa "devtoolset-*-gcc" | head -n1 | sed 's/-gcc.*//'`

    scl enable "${devtoolset}" make

    mkdir -p "${INSTALL_PREFIX}/bin"
    cp -a "workdir/bin/Linux-g++/g4simple" "${INSTALL_PREFIX}/bin/"
}


pkg_env_vars() {
cat <<-EOF
PATH="${INSTALL_PREFIX}/bin:\$PATH"
export PATH
EOF
}
