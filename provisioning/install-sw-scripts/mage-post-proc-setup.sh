# This software is licensed under the MIT "Expat" License.
#
# Copyright (c) 2022: Oliver Schulz.


DEFAULT_BUILD_OPTS=""


pkg_installed_check() {
    test -f "${INSTALL_PREFIX}/bin/mpp-config"
}


pkg_install() {
    GITHUB_USER=`echo "${PACKAGE_VERSION}" | cut -d '/' -f 1`
    GIT_BRANCH=`echo "${PACKAGE_VERSION}" | cut -d '/' -f 2`
    git clone "git@github.com:${GITHUB_USER}/mage-post-proc" mage-post-proc

    cd mage-post-proc
    git checkout "${GIT_BRANCH}"

    mkdir build
    cd build
    cmake \
        -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
        -DPYTHON_EXE=$(which python) \
        -DPIP_GLOBAL_INSTALL=ON \
        ..

    make -j $(nproc)
    make install
}


pkg_env_vars() {
cat <<-EOF
PATH="${INSTALL_PREFIX}/bin:\$PATH"
LD_LIBRARY_PATH="${INSTALL_PREFIX}/lib:\$LD_LIBRARY_PATH"
ROOT_INCLUDE_PATH="$INSTALL_PREFIX/include/mage-post-proc:\$ROOT_INCLUDE_PATH"
export PATH LD_LIBRARY_PATH ROOT_INCLUDE_PATH
EOF
}
