using GCoptimization
using Base.Test

# test gco types
@test isbits(GCOSparseDataCost) == true

# test low-level APIs
include("lowlevel.jl")

# test high-level APIs
include("highlevel.jl")

# misc.
gridgraph = gco_create(2, 2, 9)

gco_setdatacost(gridgraph, 1, 3, 1)
gco_setdatacost(gridgraph, 2, 3, 2)
gco_setdatacost(gridgraph, 3, 3, 3)
gco_setdatacost(gridgraph, 4, 3, 4)

gco_setlabeling(gridgraph, [3 3 3 3])
gco_setlabelcost(gridgraph, 7)

@test gco_energy(gridgraph)[2] == 10
@test gco_energy(gridgraph)[4] == 7

gco_setsmoothcost(gridgraph, 3, 3, 5)
@test gco_energy(gridgraph)[3] == 2 * 2 * 5

gridgraph2 = gco_create(2, 2, 9)

gco_setdatacost(gridgraph2, 1, 4, 1)
gco_setdatacost(gridgraph2, 2, 7, 2)
gco_setdatacost(gridgraph2, 3, 3, 3)
gco_setdatacost(gridgraph2, 4, 2, 4)

gco_setlabeling(gridgraph2, [1 3 2 4], [4 3 7 2])
@test gco_energy(gridgraph2)[2] == 10

@test_throws AssertionError gco_setlabeling(gridgraph2, [1 3 2 4], [4 3 7 2 5])
@test_throws AssertionError gco_setlabeling(gridgraph2, [1 3 2 4], [4 3 10 2])

gco_setlabelorder(gridgraph2, true)
