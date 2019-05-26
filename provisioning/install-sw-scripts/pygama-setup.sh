# This software is licensed under the MIT "Expat" License.
#
# Copyright (c) 2017: Oliver Schulz.


DEFAULT_BUILD_OPTS=""


pkg_installed_check() {
    test -f "${INSTALL_PREFIX}/bin/gears"
}

python_sitepkg_dir() {
    python_version=`python -V 2>&1 | head -n1 | \sed 's/[^0-9]*\([0-9][0-9]*\.[0-9][0-9]*\).*/\1/'`
    echo "${INSTALL_PREFIX}/lib/python${python_version}/site-packages"
}


pkg_install() {
    GITHUB_USER=`echo "${PACKAGE_VERSION}" | cut -d '/' -f 1`
    GIT_BRANCH=`echo "${PACKAGE_VERSION}" | cut -d '/' -f 2`
    git clone "https://github.com/${GITHUB_USER}/pygama" pygama

    cd pygama
    git checkout "${GIT_BRANCH}"

    mkdir -p `python_sitepkg_dir`
    python setup.py install --prefix="${INSTALL_PREFIX}"
    rm -rf "${INSTALL_PREFIX}/bin"
}


pkg_env_vars() {
cat <<-EOF
PYTHONPATH="`python_sitepkg_dir`:\$PYTHONPATH"
export PYTHONPATH
EOF
}
