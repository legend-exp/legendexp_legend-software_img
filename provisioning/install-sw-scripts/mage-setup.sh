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
    git clone "git@github.com:${GITHUB_USER}/MaGe" mage

    cd mage
    git checkout "${GIT_BRANCH}"
    local cpp_std=$(root-config --cflags | sed -E 's/.*-std=c\+\+([0-9][0-9]).*/\1/')

    mkdir build
    cd build
    cmake \
        -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
        -DCMAKE_CXX_STANDARD="$cpp_std" \
        -DCMAKE_CXX_FLAGS="-w" \
        ..

    make -j $(nproc)
    make install

    (
        cd "$INSTALL_PREFIX"
        ln -s share/MaGe data

        # Remove non-public data:
        cd share/MaGe
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
ROOT_INCLUDE_PATH="$INSTALL_PREFIX/include/mage:\$ROOT_INCLUDE_PATH"
export PATH LD_LIBRARY_PATH MGGENERATORDATA MGGERDAGEOMETRY ROOT_INCLUDE_PATH
EOF
}
