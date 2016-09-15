module GCoptimization

using Cxx

const libPath = joinpath(dirname(@__FILE__), "..", "deps", "usr", "lib")
const includePath = joinpath(dirname(@__FILE__), "..", "deps", "usr", "include")

global const libgco = Libdl.find_library(["libGCoptimization", "libGCoptimization-x86", "libGCoptimization-x64"], [libPath])
if isempty(libgco)
    error("GCoptimization not properly installed. Please run Pkg.build(\"GCoptimization\")")
end

function __init__()
    addHeaderDir(libPath, kind=C_System)
    Libdl.dlopen(libgco, Libdl.RTLD_GLOBAL)
    cxxinclude(includePath*"/block.h")
    cxxinclude(includePath*"/energy.h")
    cxxinclude(includePath*"/graph.h")
    cxxinclude(includePath*"/LinkedBlockList.h")
    cxxinclude(includePath*"/GCoptimization.h")
end

__init__()

# types
export GCObool, GCOnode_id, GCOLabelID, GCOEnergyTermType, GCOVarID, GCOSiteID
export GCOSparseDataCost

# low-level APIs
export GCoptimizationGridGraph, setSmoothCostVH,
       GCoptimizationGeneralGraph, setNeighbors

export expansion, alpha_expansion, swap, alpha_beta_swap

export setDataCost, setSmoothCost, setLabelCost, setLabelSubsetCost, whatLabel,
       setLabel, setLabelOrder, compute_energy, giveDataEnergy, giveSmoothEnergy,
       giveLabelEnergy, numSites, numLabels, setVerbosity

# types
include("types.jl")

# low-level APIs
include("lowlevel.jl")

# core functionalities
include("core.jl")

end # module
