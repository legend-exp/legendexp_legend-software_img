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
    (cd "${INSTALL_PREFIX}" && git checkout "${GIT_BRANCH}")

    export JULIA_DEPOT_PATH="/opt/julia/local/share/julia"
    export JULIA_PROJECT=$(dirname `julia -e 'import Pkg; println(Pkg.project().path)'`)
 
    export JUPYTER_DATA_DIR="/opt/anaconda3/share/jupyter"

    DEFAULT_NUM_THREADS=`lscpu -p | grep '^[0-9]\+,[0-9]\+,[0-9]\+,0,' | cut -d ',' -f 2 | sort | uniq | wc -l`
    export JULIA_NUM_THREADS="${DEFAULT_NUM_THREADS}"
    export OPENBLAS_NUM_THREADS="${DEFAULT_NUM_THREADS}"
    export OMP_NUM_THREADS="${DEFAULT_NUM_THREADS}"
    export GKSwstype="nul"

    julia -e 'using Pkg; pkg"registry add General https://github.com/legend-exp/LegendJuliaRegistry.git"'

    mkdir -p "${JULIA_PROJECT}"
    cp -a "${INSTALL_PREFIX}"/{Project.toml,Manifest.toml} "${JULIA_PROJECT}"
    echo -e '\n[CUDA_Runtime_jll]\nversion = "local"' >> "${JULIA_PROJECT}/LocalPreferences.toml"
    julia -e 'import Pkg; Pkg.instantiate()'
    julia -e 'using Pkg; Pkg.add(["IJulia", "Interact", "Observables", "WebIO", "Widgets", "Pluto", "PlutoUI", "PlutoHooks", "Revise", "PProf", "StatProfilerHTML", "CPUSummary", "Hwloc", "CUDA", "CUDA_Runtime_jll"]; preserve=Pkg.PRESERVE_ALL); Pkg.build("IJulia")'

    (
        cp -a "${INSTALL_PREFIX}" "./julia-tutorial-test"
        cd "./julia-tutorial-test"
        julia make.jl
        julia legend-julia-software-tutorial.jl
    )

    rm -rf /opt/julia/local/share/julia/logs
    chmod -R go+rX  "$JULIA_DEPOT_PATH"

    # Test:
    julia -e 'using LegendDataTypes'
}


pkg_env_vars() {
    true
}
