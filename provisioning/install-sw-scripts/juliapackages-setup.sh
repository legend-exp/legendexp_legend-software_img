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
    git clone "https://github.com/${GITHUB_USER}/legend-julia-environments" "${INSTALL_PREFIX}"
    (cd "${INSTALL_PREFIX}" && git checkout "${GIT_BRANCH}")

    export JULIA_DEPOT_PATH="/opt/julia/local/share/julia:"
 
    export JUPYTER_DATA_DIR="/opt/conda/share/jupyter"

    DEFAULT_NUM_THREADS=`lscpu -p | grep '^[0-9]\+,[0-9]\+,[0-9]\+,0,' | cut -d ',' -f 2 | sort | uniq | wc -l`
    export JULIA_NUM_THREADS="${DEFAULT_NUM_THREADS}"
    export OPENBLAS_NUM_THREADS="${DEFAULT_NUM_THREADS}"
    export OMP_NUM_THREADS="${DEFAULT_NUM_THREADS}"
    export GKSwstype="nul"

    julia -e 'import Pkg; Pkg.Registry.add("General"); Pkg.Registry.add(url = "https://github.com/legend-exp/LegendJuliaRegistry.git")'

    mkdir temp-jl-project
    export JULIA_PROJECT="${INSTALL_PREFIX}/base"
    echo -e '\n[CUDA_Runtime_jll]\nlocal = "true"\nversion = "local"' >> "${JULIA_PROJECT}/LocalPreferences.toml"
    julia -e 'import Pkg; Pkg.instantiate()'
    julia -e 'import Pkg; Pkg.build("ROOT", verbose=true)'

    export JULIA_PKG_PRESERVE_TIERED_INSTALLED="true"

    # Switch to default environment and add IJulia and CUDA_Runtime_jll:
    unset JULIA_PROJECT
    export JULIA_PROJECT=$(dirname `julia -e 'import Pkg; println(Pkg.project().path)'`)
    mkdir -p "${JULIA_PROJECT}"
    echo -e '\n[CUDA_Runtime_jll]\nlocal = "true"\nversion = "local"' >> "${JULIA_PROJECT}/LocalPreferences.toml"
    julia -e 'import Pkg; Pkg.add(["IJulia", "CUDA_Runtime_jll"]); Pkg.build("IJulia")'
    julia -e 'import Pkg; Pkg.build("IJulia")'

    rm /opt/julia/local/share/julia/logs/manifest_usage.toml
    # rm -rf /opt/julia/local/share/julia/logs
    chmod -R go+rX  "/opt/julia/local/share/julia"
}


pkg_env_vars() {
    true
}
