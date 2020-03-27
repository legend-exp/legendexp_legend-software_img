# This software is licensed under the MIT "Expat" License.
#
# Copyright (c) 2017: Oliver Schulz.


DEFAULT_BUILD_OPTS=""


pkg_installed_check() {
    test -f "${INSTALL_PREFIX}/Project.toml"
}


pkg_install() {
    GITHUB_USER=`echo "${PACKAGE_VERSION}" | cut -d '/' -f 1`
    GIT_BRANCH=`echo "${PACKAGE_VERSION}" | cut -d '/' -f 2`
    git clone "https://github.com/${GITHUB_USER}/legend-julia-tutorial" "${INSTALL_PREFIX}"

    export JULIA_DEPOT_PATH="/opt/julia/local/share/julia"
    export JUPYTER_DATA_DIR="/opt/anaconda3/share/jupyter"

    julia -e 'using Pkg; pkg"add IJulia; precompile"'

    julia --project="${INSTALL_PREFIX}" -e 'using Pkg; pkg"instantiate; precompile"'

    mkdir tmpprj
    cp -a "${INSTALL_PREFIX}/Project.toml" "${INSTALL_PREFIX}/Manifest.toml" tmpprj
    julia --project=tmpprj -e 'using Pkg; pkg"update; precompile"'
}


pkg_env_vars() {
    true
}
