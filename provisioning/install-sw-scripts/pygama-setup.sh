# This software is licensed under the MIT "Expat" License.
#
# Copyright (c) 2017: Oliver Schulz.


DEFAULT_BUILD_OPTS=""


pkg_installed_check() {
    test -f "${INSTALL_PREFIX}/lib/python3.7/site-packages/site.py"
}


pkg_install() {
    GITHUB_USER=`echo "${PACKAGE_VERSION}" | cut -d '/' -f 1`
    GIT_BRANCH=`echo "${PACKAGE_VERSION}" | cut -d '/' -f 2`
    git clone --recursive "https://github.com/${GITHUB_USER}/pygama" pygama
    (cd pygama && git checkout "${GIT_BRANCH}" && git submodule update)

    export PYTHONUSERBASE="${INSTALL_PREFIX}"

    # pygama needs tinydb (missing in pygama deps?)
    python3 -m pip install --user tinydb

    # Just to install pygama deps:
    python3 -m pip install --user -e pygama

    # Install pygama to INSTALL_PREFIX:
    cd pygama
    python setup.py install --prefix="${INSTALL_PREFIX}"
}


pkg_env_vars() {
cat <<-EOF
PYTHONPATH="`python_sitepkg_dir`:\$PYTHONPATH"
export PYTHONPATH
EOF
}
