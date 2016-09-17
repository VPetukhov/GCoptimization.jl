# low-level wrappers

# grid graph
GCoptimizationGridGraph(width::GCOSiteID, height::GCOSiteID, numLabels::GCOLabelID) = @cxxnew GCoptimizationGridGraph(width, height, numLabels)
setSmoothCostVH(gco::Cxx.CppPtr, smoothArrayPtr::Ptr{GCOEnergyTermType}, vCostsPtr::Ptr{GCOEnergyTermType}, hCostsPtr::Ptr{GCOEnergyTermType})::Void = @cxx gco -> setSmoothCostVH(smoothArrayPtr, vCostsPtr, hCostsPtr)

# general graph
# TODO: support setAllNeighbors
GCoptimizationGeneralGraph(num_sites::GCOSiteID, num_labels::GCOLabelID) = @cxxnew GCoptimizationGeneralGraph(num_sites, num_labels)
setNeighbors(gco::Cxx.CppPtr, site1::GCOSiteID, site2::GCOSiteID, weight::GCOEnergyTermType=GCOEnergyTermType(1))::Void = @cxx gco -> setNeighbors(site1, site2, weight)

# expansion
# "Peforms expansion algorithm. Runs the number of iterations specified by max_num_iterations.
#  If no input specified, runs until convergence. Returns total energy of labeling."
expansion(gco::Cxx.CppPtr, max_num_iterations::Cint=Cint(-1))::GCOEnergyType = @cxx gco -> expansion(max_num_iterations)

# "Peforms  expansion on one label, specified by the input parameter alpha_label."
alpha_expansion(gco::Cxx.CppPtr, alpha_label::GCOLabelID)::GCObool = @cxx gco -> alpha_expansion(alpha_label)

# swap
# "Peforms swap algorithm. Runs it the specified number of iterations.
#  If no input is specified,runs until convergence."
swap(gco::Cxx.CppPtr, max_num_iterations::Cint=Cint(-1))::GCOEnergyType = @cxx gco -> swap(max_num_iterations)

# "Peforms  swap on a pair of labels, specified by the input parameters alpha_label, beta_label"
alpha_beta_swap(gco::Cxx.CppPtr, alpha_label::GCOLabelID, beta_label::GCOLabelID)::Void = @cxx gco -> alpha_beta_swap(alpha_label, beta_label)

# "Peforms swap on a pair of labels, specified by the input parameters alpha_label, beta_label,
#  only on the sitess in the specified arrays, alphaSites and betaSitess, and the array sizes
#  are, respectively, alpha_size and beta_size"
alpha_beta_swap(gco::Cxx.CppPtr, alpha_label::GCOLabelID, beta_label::GCOLabelID, alphaSitesPtr::Ptr{GCOSiteID}, alpha_size::GCOSiteID, betaSitesPtr::Ptr{GCOSiteID}, beta_size::GCOSiteID)::Void = @cxx gco -> alpha_beta_swap(alpha_label, beta_label, alphaSitesPtr, alpha_size, betaSitesPtr, beta_size)

# setDataCost
# "Set cost for all (SiteID,LabelID) pairs. Default data cost is all zeros."
function setDataCost(gco::Cxx.CppPtr, dataCostFunc::Function)::Void
    const fn = cfunction(dataCostFunc, GCOEnergyTermType, (GCOSiteID, GCOLabelID))
    @cxx gco -> setDataCost(icxx"($GCOEnergyTermType (*)($GCOSiteID,$GCOLabelID))($fn)")
end
function setDataCost(gco::Cxx.CppPtr,  dataCostFuncExtra::Function, extraData::Ptr{Void})::Void
    const fn = cfunction(dataCostFuncExtra, GCOEnergyTermType, (GCOSiteID, GCOLabelID, Ptr{Void}))
    @cxx gco -> setDataCost(icxx"($GCOEnergyTermType (*)($GCOSiteID,$GCOLabelID,void *))($fn)", extraData)
end
setDataCost(gco::Cxx.CppPtr, dataArrayPtr::Ptr{GCOEnergyTermType})::Void = @cxx gco -> setDataCost(dataArrayPtr)
setDataCost(gco::Cxx.CppPtr, s::GCOSiteID, l::GCOLabelID, e::GCOEnergyTermType)::Void = @cxx gco -> setDataCost(s, l, e)

# TODO: support setDataCostFunctor

# "Set cost of assigning 'l' to a specific subset of sites.
#  The sites are listed as (SiteID,cost) pairs."
setDataCost(gco::Cxx.CppPtr, l::GCOLabelID, costsPtr::Ptr{GCOSparseDataCost}, count::GCOSiteID)::Void = @cxx gco -> setDataCost(l, costsPtr, count)


# setSmoothCost
# "Set cost for all (LabelID,LabelID) pairs; the actual smooth cost is then weighted
#  at each pair of on neighbors. Defaults to Potts model (0 if l1==l2, 1 otherwise)"
function setSmoothCost(gco::Cxx.CppPtr, smoothCostFunc::Function)::Void
    const fn = cfunction(smoothCostFunc, GCOEnergyTermType, (GCOSiteID, GCOSiteID, GCOLabelID, GCOLabelID))
    @cxx gco -> setSmoothCost(icxx"($GCOEnergyTermType (*)($GCOSiteID,$GCOSiteID,$GCOLabelID,$GCOLabelID))($fn);")
end
function setSmoothCost(gco::Cxx.CppPtr, smoothCostFuncExtra::Function, extraData::Ptr{Void})::Void
    const fn = cfunction(smoothCostFuncExtra, GCOEnergyTermType, (GCOSiteID, GCOSiteID, GCOLabelID, GCOLabelID, Ptr{Void}))
    @cxx gco -> setSmoothCost(icxx"($GCOEnergyTermType (*)($GCOSiteID,$GCOSiteID,$GCOLabelID,$GCOLabelID,void *))($fn))", extraData)
end
setSmoothCost(gco::Cxx.CppPtr, l1::GCOLabelID, l2::GCOLabelID, e::GCOEnergyTermType)::Void = @cxx gco -> setSmoothCost(l1, l2, e)
setSmoothCost(gco::Cxx.CppPtr, smoothArrayPtr::Ptr{GCOEnergyTermType})::Void = @cxx gco -> setSmoothCost(smoothArrayPtr)

# TODO: support setSmoothCostFunctor

# setLabelCost
# "Sets the cost of using label in the solution.
#  Set either as uniform cost, or an individual per-label cost."
setLabelCost(gco::Cxx.CppPtr, cost::GCOEnergyTermType)::Void = @cxx gco -> setLabelCost(cost)
setLabelCost(gco::Cxx.CppPtr, costArrayPtr::Ptr{GCOEnergyTermType})::Void = @cxx gco -> setLabelCost(costArrayPtr)
setLabelSubsetCost(gco::Cxx.CppPtr, labelsPtr::Ptr{GCOLabelID}, numLabels::GCOLabelID, cost::GCOEnergyTermType)::Void = @cxx gco -> setLabelSubsetCost(labelsPtr, numLabels, cost)

# whatLabel
# "Returns current label assigned to input site"
whatLabel(gco::Cxx.CppPtr, site::GCOSiteID)::GCOLabelID = @cxx gco -> whatLabel(site)
whatLabel(gco::Cxx.CppPtr, start::GCOSiteID, count::GCOSiteID, labelingPtr::Ptr{GCOLabelID})::Void = @cxx gco -> whatLabel(start, count, labelingPtr)

# setLabel
# "This function can be used to change the label of any site at any time"
setLabel(gco::Cxx.CppPtr, site::GCOSiteID, label::GCOLabelID)::Void = @cxx gco -> setLabel(site, label)

# setLabelOrder
# "setLabelOrder(false) sets the order to be not random; setLabelOrder(true)
#  sets the order to random. By default, the labels are visited in non-random order
#  for both the swap and alpha-expansion moves
#  Note that srand() must be initialized with an appropriate seed in order for
#  random order to take effect!"
setLabelOrder(gco::Cxx.CppPtr, isRandom::GCObool)::Void = @cxx gco -> setLabelOrder(isRandom)
setLabelOrder(gco::Cxx.CppPtr, orderPtr::Ptr{GCOLabelID}, size::GCOLabelID)::Void = @cxx gco -> setLabelOrder(orderPtr, size)

# compute_energy
# "Returns total energy for the current labeling"
compute_energy(gco::Cxx.CppPtr)::GCOEnergyType = @cxx gco -> compute_energy()

# give*energy
# "Returns separate Data, Smooth, and Label energy of current labeling"
giveDataEnergy(gco::Cxx.CppPtr)::GCOEnergyType = @cxx gco -> giveDataEnergy()
giveSmoothEnergy(gco::Cxx.CppPtr)::GCOEnergyType = @cxx gco -> giveSmoothEnergy()
giveLabelEnergy(gco::Cxx.CppPtr)::GCOEnergyType = @cxx gco -> giveLabelEnergy()

# numSites & numLabels
# "Returns number of sites/labels as specified in the constructor"
numSites(gco::Cxx.CppPtr)::GCOSiteID = @cxx gco -> numSites()
numLabels(gco::Cxx.CppPtr)::GCOLabelID = @cxx gco -> numLabels()

# setVerbosity
# "Prints output to stdout during exansion/swap execution.
#   0 => no output
#   1 => cycle-level output (cycle number, current energy)
#   2 => expansion-/swap-level output (label(s), current energy)"
setVerbosity(gco::Cxx.CppPtr, level::Cint)::Void = @cxx gco -> setVerbosity(level)
