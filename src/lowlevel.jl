# low-level wrappers

# grid graph
GCoptimizationGridGraph(width::GCOSiteID, height::GCOSiteID, numLabels::GCOLabelID) = @cxxnew GCoptimizationGridGraph(width, height, numLabels)
setSmoothCostVH(gco::Cxx.CppPtr, smoothArrayPtr::Ptr{GCOEnergyTermType}, vCostsPtr::Ptr{GCOEnergyTermType}, hCostsPtr::Ptr{GCOEnergyTermType})::Void = @cxx gco -> setSmoothCostVH(smoothArrayPtr, vCostsPtr, hCostsPtr)

# general graph
# TODO: support setAllNeighbors
GCoptimizationGeneralGraph(num_sites::GCOSiteID, num_labels::GCOLabelID) = @cxxnew GCoptimizationGeneralGraph(num_sites, num_labels)
setNeighbors(gco::Cxx.CppPtr, site1::GCOSiteID, site2::GCOSiteID, weight::GCOEnergyTermType=GCOEnergyTermType(1))::Void = @cxx gco -> setNeighbors(site1, site2, weight)

# expansion
expansion(gco::Cxx.CppPtr, max_num_iterations::Cint=Cint(-1))::GCOEnergyType = @cxx gco -> expansion(max_num_iterations)
alpha_expansion(gco::Cxx.CppPtr, alpha_label::GCOLabelID)::GCObool = @cxx gco -> alpha_expansion(alpha_label)

# swap
swap(gco::Cxx.CppPtr, max_num_iterations::Cint=Cint(-1))::GCOEnergyType = @cxx gco -> swap(max_num_iterations)
alpha_beta_swap(gco::Cxx.CppPtr, alpha_label::GCOLabelID, beta_label::GCOLabelID)::Void = @cxx gco -> alpha_beta_swap(alpha_label, beta_label)
alpha_beta_swap(gco::Cxx.CppPtr, alpha_label::GCOLabelID, beta_label::GCOLabelID, alphaSitesPtr::Ptr{GCOSiteID}, alpha_size::GCOSiteID, betaSitesPtr::Ptr{GCOSiteID}, beta_size::GCOSiteID)::Void = @cxx gco -> alpha_beta_swap(alpha_label, beta_label, alphaSitesPtr, alpha_size, betaSitesPtr, beta_size)

# setDataCost
function setDataCost(gco::Cxx.CppPtr, dataCostFunc::Function)::Void
    const fn = cfunction(dataCostFunc, GCOEnergyTermType, (GCOSiteID, GCOLabelID))
    @cxx gco -> setDataCost(icxx"($GCOEnergyTermType (*)($GCOSiteID,$GCOLabelID))($fn)")
end
function setDataCost(gco::Cxx.CppPtr,  dataCostFuncExtra::Function, extraData)::Void
    const fn = cfunction(dataCostFuncExtra, GCOEnergyTermType, (GCOSiteID, GCOLabelID, Ptr{Void}))
    @cxx gco -> setDataCost(icxx"($GCOEnergyTermType (*)($GCOSiteID,$GCOLabelID,Ptr{Void}))($fn)", Ptr{Void}(extraData))
end
setDataCost(gco::Cxx.CppPtr, dataArrayPtr::Ptr{GCOEnergyTermType})::Void = @cxx gco -> setDataCost(dataArrayPtr)
setDataCost(gco::Cxx.CppPtr, s::GCOSiteID, l::GCOLabelID, e::GCOEnergyTermType)::Void = @cxx gco -> setDataCost(s, l, e)
setDataCost(gco::Cxx.CppPtr, l::GCOLabelID, costsPtr::Ptr{GCOSparseDataCost}, count::GCOSiteID)::Void = @cxx gco -> setDataCost(l, costsPtr, count)

# setSmoothCost
# TODO: support setSmoothCostFunctor
function setSmoothCost(gco::Cxx.CppPtr, smoothCostFunc::Function)::Void
    const fn = cfunction(smoothCostFunc, GCOEnergyTermType, (GCOSiteID, GCOSiteID, GCOLabelID, GCOLabelID))
    @cxx gco -> setSmoothCost(icxx"($GCOEnergyTermType (*)($GCOSiteID,$GCOSiteID,$GCOLabelID,$GCOLabelID))($fn);")
end
function setSmoothCost(gco::Cxx.CppPtr, smoothCostFuncExtra::Function, extraData)::Void
    const fn = cfunction(smoothCostFuncExtra, GCOEnergyTermType, (GCOSiteID, GCOSiteID, GCOLabelID, GCOLabelID, Ptr{Void}))
    @cxx gco -> setSmoothCost(icxx"($GCOEnergyTermType (*)($GCOSiteID,$GCOSiteID,$GCOLabelID,$GCOLabelID,Ptr{Void})($fn))", Ptr{Void}(extraData))
end
setSmoothCost(gco::Cxx.CppPtr, l1::GCOLabelID, l2::GCOLabelID, e::GCOEnergyTermType)::Void = @cxx gco -> setSmoothCost(l1, l2, e)
setSmoothCost(gco::Cxx.CppPtr, smoothArray::GCOEnergyTermType)::Void = @cxx gco -> setSmoothCost(Ref(smoothArray))

# setLabelCost
setLabelCost(gco::Cxx.CppPtr, cost::GCOEnergyTermType)::Void = @cxx gco -> setLabelCost(cost)
setLabelCost(gco::Cxx.CppPtr, costArray::GCOEnergyTermType)::Void = @cxx gco -> setLabelCost(Ref(costArray))
setLabelSubsetCost(gco::Cxx.CppPtr, labels::GCOLabelID, numLabels::GCOLabelID, cost::GCOEnergyTermType)::Void = @cxx gco -> setLabelSubsetCost(labels, numLabels, cost)

# whatLabel
whatLabel(gco::Cxx.CppPtr, site::GCOSiteID)::GCOLabelID = @cxx gco -> whatLabel(site)
whatLabel(gco::Cxx.CppPtr, start::GCOSiteID, count::GCOSiteID, labelingPtr::Ptr{GCOLabelID})::Void = @cxx gco -> whatLabel(start, count, labelingPtr)

# setLabel
setLabel(gco::Cxx.CppPtr, site::GCOSiteID, label::GCOLabelID)::Void = @cxx gco -> setLabel(site, label)

# setLabelOrder
setLabelOrder(gco::Cxx.CppPtr, isRandom::GCObool)::Void = @cxx gco -> setLabelOrder(isRandom)
setLabelOrder(gco::Cxx.CppPtr, order::GCOLabelID, size::GCOLabelID)::Void = @cxx gco -> setLabelOrder(order, size)

# compute_energy
compute_energy(gco::Cxx.CppPtr)::GCOEnergyType = @cxx gco -> compute_energy()

# give*energy
giveDataEnergy(gco::Cxx.CppPtr)::GCOEnergyType = @cxx gco -> giveDataEnergy()
giveSmoothEnergy(gco::Cxx.CppPtr)::GCOEnergyType = @cxx gco -> giveSmoothEnergy()
giveLabelEnergy(gco::Cxx.CppPtr)::GCOEnergyType = @cxx gco -> giveLabelEnergy()

# numSites & numLabels
numSites(gco::Cxx.CppPtr)::GCOSiteID = @cxx gco -> numSites()
numLabels(gco::Cxx.CppPtr)::GCOLabelID = @cxx gco -> numLabels()

# setVerbosity
setVerbosity(gco::Cxx.CppPtr, level::Cint)::Void = @cxx gco -> setVerbosity(level)


export GCoptimizationGridGraph, setSmoothCostVH,
       GCoptimizationGeneralGraph, setNeighbors

export expansion, alpha_expansion, swap, alpha_beta_swap

export setDataCost, setSmoothCost, setLabelCost, setLabelSubsetCost, whatLabel,
       setLabel, setLabelOrder, compute_energy, giveDataEnergy, giveSmoothEnergy,
       giveLabelEnergy, numSites, numLabels, setVerbosity
