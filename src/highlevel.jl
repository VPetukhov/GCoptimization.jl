# high-level wrappers

# create
gco_create(width, height, labelNum) = GCoptimizationGridGraph(width, height, labelNum)
gco_create(siteNum, labelNum) = GCoptimizationGeneralGraph(siteNum, labelNum)

# set neighbors
gco_setneighbors(handle, site1, site2) = setNeighbors(handle, site1-1, site2-1)
gco_setneighbors(handle, site1, site2, weight) = setNeighbors(handle, site1-1, site2-1, weight)
function gco_setneighbors(handle, weight::Matrix)
    r, c = size(weight)
    for j in 1:c, i in 1:j-1
        gco_setneighbors(handle, i, j, weight[i,j])
    end
end

# datacost
gco_setdatacost(handle, datacost::Vector) = setDataCost(handle, datacost)
gco_setdatacost(handle, datacost::Matrix) = setDataCost(handle, [datacost...;])
gco_setdatacost(handle, site, label, energy) = setDataCost(handle, site-1, label-1, energy)

# smoothcost
gco_setsmoothcost(handle, smoothcost::Vector) = setSmoothCost(handle, smoothcost)
gco_setsmoothcost(handle, smoothcost::Matrix) = setSmoothCost(handle, [smoothcost...;])
gco_setsmoothcost(handle, label1, label2, energy) = setSmoothCost(handle, label1-1, label2-1, energy)

# labelcost
gco_setlabelcost(handle, labelcost::Integer) = setLabelCost(handle, labelcost)
gco_setlabelcost(handle, labelcost::Vector) = setLabelCost(handle, labelcost)
gco_setlabelcost(handle, cost, labelIndices) = setLabelSubsetCost(handle, labelIndices-1, length(labelIndices), cost)

# expansion & swap
gco_expansion(handle, maxIterationNum=-1) = expansion(handle, maxIterationNum)
gco_αexpansion(handle, αlabel) = alpha_expansion(handle, αlabel-1)
gco_swap(handle, maxIterationNum=-1) = swap(handle, maxIterationNum)
gco_αβswap(handle, αlabel, βlabel) = alpha_beta_swap(handle, αlabel-1, βlabel-1)

# compute_energy
gco_energy(handle) = return compute_energy(handle), giveDataEnergy(handle), giveSmoothEnergy(handle), giveLabelEnergy(handle)

# get labeling
gco_getlabeling(handle) = [whatLabel(handle, i-1)+1 for i in 1:numSites(handle)]

function gco_getlabeling(handle, site)
    @assert 0 < site <= numSites(handle) "invalid site: $site"
    return whatLabel(handle, site-1)+1
end

function gco_getlabeling(handle, sites::Vector)
    result = Vector{Int}(length(sites))
    for i in eachindex(sites)
        @assert 0 < sites[i] <= numSites(handle) "invalid site: $(sites[i])"
        result[i] = whatLabel(handle, sites[i]-1)+1
    end
    return result
end

# set labeling
function gco_setlabeling(handle, labeling::Vector)
    @assert 0 < length(labeling) <= numSites(handle) "no label or too many labels... $(length(labeling))"
    for i in eachindex(labeling)
        @assert 0 < labeling[i] <= numLabels(handle) "invalid label: $(labeling[i])"
        setLabel(handle, i-1, labeling[i]-1)
    end
end
gco_setlabeling(handle, labeling::Matrix) = get_setlabeling(handle, [labeling...;])

function gco_setlabeling(handle, sites::Vector, labeling::Vector)
    @assert 0 < length(labeling) <= numSites(handle) "no label or too many labels... $(length(labeling))"
    for i in sites
        @assert 0 < labeling[i] <= numLabels(handle) "invalid label: $(labeling[i])"
        setLabel(handle, i-1, labeling[i]-1)
    end
end
gco_setlabeling(handle, sites::Matrix, labeling::Matrix) = get_setlabeling(handle, [sites...;], [labeling...;])

# set label order
gco_setlabelorder(handle, random::Bool) = setLabelOrder(handle, random)
gco_setlabelorder(handle, order, size) = setLabelOrder(handle, order, size)
