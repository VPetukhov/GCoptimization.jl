# high-level wrappers

# create
gco_create(width, height, labelNum) = GCoptimizationGridGraph(width, height, labelNum)
gco_create(siteNum, labelNum) = GCoptimizationGeneralGraph(siteNum, labelNum)

# set neighbors
gco_setneighbors(handle, site1, site2) = setNeighbors(handle, site1, site2)
gco_setneighbors(handle, site1, site2, weight) setNeigh(handle, site1, site2, weight)

# datacost
gco_setdatacost(handle, datacost::Vector) = setDataCost(handle, datacost)
gco_setdatacost(handle, datacost::Matrix) = setDataCost(handle, [datacost...;])
gco_setdatacost(handle, site, label, energy) = setDataCost(handle, site, label, energy)

# smoothcost
gco_setsmoothcost(handle, smoothcost::Vector) = setSmoothCost(handle, smoothcost)
gco_setsmoothcost(handle, smoothcost::Matrix) = setSmoothCost(handle, [smoothcost...;])
gco_setsmoothcost(handle, label1, label2, energy) = setSmoothCost(handle, label1, label2, energy)

# labelcost
gco_setlabelcost(handle, labelcost::Integer) = setLabelCost(handle, labelcost)
gco_setlabelcost(handle, labelcost::Vector) = setLabelCost(handle, labelcost)

# expansion & swap
gco_expansion(handle, maxIterationNum=-1) = expansion(handle, maxIterationNum)
gco_swap(handle, maxIterationNum=-1) = swap(handle, maxIterationNum)

# compute_energy
gco_energy(handle) = return compute_energy(handle), giveDataEnergy(handle), giveSmoothEnergy(handle), giveLabelEnergy(handle)

# get labeling
gco_getlabeling(handle, site) = whatLabel(handle, site-1)
gco_getlabeling(handle) = [whatLabel[handle, i-1] for i in 1:numSites(handle)]
gco_getlabeling(handle, sites::Vector) = [whatLabel[handle, i-1] for i in sites]

# set labeling
function gco_setlabeling(handle, labeling::Vector)
    for i in eachindex(labeling)
        setLabel(handle, i-1, labeling[i-1])
    end
end
gco_setlabeling(handle, labeling::Matrix) = get_setlabeling(handle, [labeling...;])

function gco_setlabeling(handle, sites::Vector, labeling::Vector)
    for i in sites
        setLabel(handle, i-1, labeling[i-1])
    end
end
gco_setlabeling(handle, sites::Matrix, labeling::Matrix) = get_setlabeling(handle, [sites...;], [labeling...;])

# set label order
gco_setlabelorder(handle, random::Bool) = setLabelOrder(handle, random)
gco_setlabelorder(handle, order, size) = setLabelOrder(handle, order, size)
