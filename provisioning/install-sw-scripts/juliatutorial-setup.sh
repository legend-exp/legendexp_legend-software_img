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

    export JULIA_DEPOT_PATH="/opt/julia/local/share/julia:"
 
    export JUPYTER_DATA_DIR="/opt/conda/share/jupyter"

    DEFAULT_NUM_THREADS=`lscpu -p | grep '^[0-9]\+,[0-9]\+,[0-9]\+,0,' | cut -d ',' -f 2 | sort | uniq | wc -l`
    export JULIA_NUM_THREADS="${DEFAULT_NUM_THREADS}"
    export OPENBLAS_NUM_THREADS="${DEFAULT_NUM_THREADS}"
    export OMP_NUM_THREADS="${DEFAULT_NUM_THREADS}"
    export GKSwstype="nul"

    julia -e 'using Pkg; pkg"registry add General https://github.com/legend-exp/LegendJuliaRegistry.git"'

    mkdir temp-jl-project
    export JULIA_PROJECT="`pwd`/temp-jl-project"
    MANIFEST_NAME=`julia -e 'println("Manifest-v$(VERSION.major).$(VERSION.minor).toml")'`
    cp -a "${INSTALL_PREFIX}"/{Project.toml,"$MANIFEST_NAME"} "${JULIA_PROJECT}"
    echo -e '\n[CUDA_Runtime_jll]\nlocal = "true"\nversion = "local"' >> "${JULIA_PROJECT}/LocalPreferences.toml"
    julia -e 'import Pkg; Pkg.instantiate()'

    julia -e 'using Pkg; Pkg.add(["CUDA", "CUDA_Runtime_jll"])'
    julia -e 'using Pkg; Pkg.add(["BenchmarkTools", "Infiltrator", "Revise", "PProf", "PrecompileTools", "SnoopCompile", "StatProfilerHTML", "CPUSummary", "Cthulhu", "Hwloc", "CUDA", "CUDA_Runtime_jll"])'
    julia -e 'using Pkg; Pkg.add(["Plots", "GR", "PlotlyJS", "PyPlot", "UnicodePlots"])'
    julia -e 'using Pkg; Pkg.add(["Interact", "Observables", "WebIO", "Widgets", "Pluto", "PlutoUI", "PlutoHooks", "Revise", "PProf", "StatProfilerHTML", "CPUSummary", "Hwloc", "CUDA", "CUDA_Runtime_jll"])'
    julia -e 'using Pkg; Pkg.add(["BAT", "MeasureBase", "ValueShapes", "DensityInterface", "InverseFunctions", "ChangesOfVariables", "FunctionChains"])'
    julia -e 'using Pkg; Pkg.add(["Enzyme", "ForwardDiff", "Zygote", "ChainRulesCore", "ChainRules", "ChainRulesTestUtils"])'
    julia -e 'using Pkg; Pkg.add(["Geant4", "ROOT"]); Pkg.build("ROOT", verbose=true)'

    # Delete packages that need frequent updates:
    julia -e 'using Pkg; Pkg.rm(["LegendDataTypes", "LegendHDF5IO", "LegendTextIO"])'
    julia -e 'import Pkg, Dates; Pkg.gc(collect_delay = Dates.Day(0))'

    # Add IJulia to default environment:
    unset JULIA_PROJECT
    export JULIA_PROJECT=$(dirname `julia -e 'import Pkg; println(Pkg.project().path)'`)
    julia -e 'using Pkg; Pkg.add(["IJulia"]); Pkg.build("IJulia")'

    rm /opt/julia/local/share/julia/logs/manifest_usage.toml
    # rm -rf /opt/julia/local/share/julia/logs
    chmod -R go+rX  "/opt/julia/local/share/julia"
}


pkg_env_vars() {
    true
}
