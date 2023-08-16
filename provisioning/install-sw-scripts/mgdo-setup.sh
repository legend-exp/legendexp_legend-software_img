# This software is licensed under the MIT "Expat" License.
#
# Copyright (c) 2022: Oliver Schulz.


DEFAULT_BUILD_OPTS=""


pkg_installed_check() {
    test -f "${INSTALL_PREFIX}/bin/mgdo-config"
}


pkg_install() {
    GITHUB_USER=`echo "${PACKAGE_VERSION}" | cut -d '/' -f 1`
    GIT_BRANCH=`echo "${PACKAGE_VERSION}" | cut -d '/' -f 2`
    git clone "git@github.com:${GITHUB_USER}/MGDO" mgdo

    cd mgdo
    git checkout "${GIT_BRANCH}"

    ./configure \
        --prefix="$INSTALL_PREFIX" \
        --enable-streamers \
        --enable-tam \
        --enable-tabree

    make svninfo static -j$(nproc)
    make -j1
    make install
}


pkg_env_vars() {
cat <<-EOF
PATH="${INSTALL_PREFIX}/bin:\$PATH"
LD_LIBRARY_PATH="${INSTALL_PREFIX}/lib:\$LD_LIBRARY_PATH"
ROOT_INCLUDE_PATH="$INSTALL_PREFIX/include/mgdo:$INSTALL_PREFIX/include/tam:\$ROOT_INCLUDE_PATH"
export PATH LD_LIBRARY_PATH ROOT_INCLUDE_PATH
EOF
}
