# This software is licensed under the MIT "Expat" License.
#
# Copyright (c) 2017: Oliver Schulz.


DEFAULT_BUILD_OPTS=""


pkg_installed_check() {
    test -d "${INSTALL_PREFIX}/lib/python*/site-packages/pyfcutils-*/pyfcutils"
}


pkg_install() {
    GITHUB_USER=`echo "${PACKAGE_VERSION}" | cut -d '/' -f 1`
    GIT_BRANCH=`echo "${PACKAGE_VERSION}" | cut -d '/' -f 2`
    git clone "https://github.com/${GITHUB_USER}/pyfcutils" pyfcutils
    (cd pyfcutils && git checkout "${GIT_BRANCH}")

    export PYTHONUSERBASE="${INSTALL_PREFIX}"
    python3 -m pip install --user ./pyfcutils
}


pkg_env_vars() {
cat <<-EOF
EOF
}
