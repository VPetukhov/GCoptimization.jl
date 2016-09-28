using GCoptimization
using Base.Test

# test gco types
@test isbits(GCOSparseDataCost) == true

# test low-level APIs
include("lowlevel.jl")

# test high-level APIs
include("highlevel.jl")
