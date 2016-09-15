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
include("types.jl")

# low-level APIs
include("lowlevel.jl")

end # module
