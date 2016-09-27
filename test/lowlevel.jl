# test file for low-level APIs

# constants
const width = 10
const height = 5
const pixelNum = width * height
const labelNum = 7

# grid graph
gridgraph = GCoptimizationGridGraph(width, height, labelNum)

for i = 0:pixelNum-1, l = 0:labelNum-1
    if i < 25
        l == 0 ? setDataCost(gridgraph, i, l, 0) : setDataCost(gridgraph, i, l, 10)
    else
        l == 5 ? setDataCost(gridgraph, i, l, 0) : setDataCost(gridgraph, i, l, 10)
    end
end

for l1 = 0:labelNum-1, l2 = 0:labelNum-1
    cost = (l1-l2)^2 <= 4 ? (l1-l2)^2 : 4
    setSmoothCost(gridgraph, l1, l2, cost)
end

@test compute_energy(gridgraph) == 250
@test expansion(gridgraph) == 44
@test expansion(gridgraph, 2) == 44

# data array & smooth array
data = Matrix{Int}(labelNum, pixelNum)
for i = 1:pixelNum, l = 1:labelNum
    if i <= 25
        if l == 1
            data[l,i] = 0
        else
            data[l,i] = 10
        end
    else
        if l == 6
            data[l,i] = 0
        else
            data[l,i] = 10
        end
    end
end
data = [data...;]

smooth = Matrix{Int}(labelNum, labelNum)
for l1 = 1:labelNum, l2 = 1:labelNum
    smooth[l1,l2] = (l1-l2)*(l1-l2) <= 4  ? (l1-l2)*(l1-l2) : 4;
end
smooth = [smooth...;]

gridgraphArray = GCoptimizationGridGraph(width, height, labelNum)
setDataCost(gridgraphArray, data)
setSmoothCost(gridgraphArray, smooth)

@test compute_energy(gridgraphArray) == 250
@test swap(gridgraphArray) == 44

# H & V
H = [i+(i+1)%3 for i in 0:pixelNum-1]
V = [i*(i+width)%7 for i in 0:pixelNum-1]

gridgraphHV = GCoptimizationGridGraph(width, height, labelNum)
setDataCost(gridgraphHV, data)
setSmoothCostVH(gridgraphHV, smooth, V, H)

@test compute_energy(gridgraphHV) == 250
@test swap(gridgraphHV, 2) == 170

# pass julia function to C++
function dataFn(p::GCOSiteID, l::GCOLabelID)::GCOEnergyTermType
    if p < 25
        return l == 0 ? 0 : 10
    else
        return l == 5 ? 0 : 10
    end
end

smoothFn(p1::GCOSiteID, p2::GCOSiteID, l1::GCOLabelID, l2::GCOLabelID)::GCOEnergyTermType = (l1-l2)*(l1-l2) <= 4 ? (l1-l2)*(l1-l2) : 4

gridgraphFn = GCoptimizationGridGraph(width, height, labelNum)

setDataCost(gridgraphFn, dataFn)
setSmoothCost(gridgraphFn, smoothFn)

@test compute_energy(gridgraphFn) == 250
@test swap(gridgraphFn, 2) == 44

# general graph
generalgraph = GCoptimizationGeneralGraph(pixelNum, labelNum)

setDataCost(generalgraph, data)
setSmoothCost(generalgraph, smooth)

for y = 0:height-1, x = 1:width-1
    setNeighbors(generalgraph, x+y*width, x-1+y*width)
end

for y = 1:height-1, x = 0:width-1
    setNeighbors(generalgraph, x+y*width, x+(y-1)*width)
end

@test compute_energy(generalgraph) == 250
@test expansion(generalgraph) == 44

# with non-one weight
generalgraphWeight = GCoptimizationGeneralGraph(pixelNum, labelNum)

setDataCost(generalgraphWeight, data)
setSmoothCost(generalgraphWeight, smooth)

for y = 0:height-1, x = 1:width-1
    p1 = x - 1 + y*width
    p2 = x + y*width
    setNeighbors(generalgraphWeight, p1, p2, p1+p2)
end

for y = 1:height-1, x = 0:width-1
    p1 = x + (y-1)*width
    p2 = x + y*width
    setNeighbors(generalgraphWeight, p1, p2, p1*p2)
end

@test compute_energy(generalgraphWeight) == 250
@test expansion(generalgraphWeight) == 244

# miscellaneous
@test numSites(gridgraph) == width * height
@test numLabels(gridgraph) == labelNum

@test whatLabel(gridgraph, 24) == 0
@test whatLabel(gridgraph, 25) == 5
labeling = Vector{Cint}(4)
whatLabel(gridgraph, 23, 4, labeling)
@test labeling == [0, 0, 5, 5]

@test giveDataEnergy(gridgraph) == 0
@test giveSmoothEnergy(gridgraph) == 44
@test giveLabelEnergy(gridgraph) == 0


alpha_expansion(gridgraph, 0)
alpha_beta_swap(gridgraph, 0, 5)

setVerbosity(gridgraph, 2)

# add test for setLabel
setLabel(gridgraph, 10, 2)
whatLabel(gridgraph, 10) == 2
