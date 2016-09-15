# core functionalities

# grid graph
GCoptimizationGridGraph(width::Integer, height::Integer, numLabels::Integer) = GCoptimizationGridGraph(GCOSiteID(width), GCOSiteID(height), GCOLabelID(numLabels))
setSmoothCostVH(gco::Cxx.CppPtr, smoothArray::Vector{Integer}, vCosts::Vector{Integer},
                hCosts::Vector{Integer}) = setSmoothCostVH(gco, Ref(convert(Vector{GCOEnergyTermType}, smoothArray)),
                                                                Ref(convert(Vector{GCOEnergyTermType}, vCosts)),
                                                                Ref(convert(Vector{GCOEnergyTermType}, hCosts)))

# general graph
GCoptimizationGeneralGraph(numSites::Integer, numLabels::Integer) = GCoptimizationGeneralGraph(GCOSiteID(numSites), GCOLabelID(numLabels))
setNeighbors(gco::Cxx.CppPtr, site1::Integer, site2::Integer) = setNeighbors(gco, GCOSiteID(site1), GCOSiteID(site2))
setNeighbors(gco::Cxx.CppPtr, site1::Integer, site2::Integer, weight::Integer) = setNeighbors(gco, GCOSiteID(site1), GCOSiteID(site2), GCOEnergyTermType(weight))

# expansion
expansion(gco::Cxx.CppPtr, maxIterationNum::Integer) = expansion(gco, Cint(maxIterationNum))
alpha_expansion(gco::Cxx.CppPtr, alphaLabel::Integer) = alpha_expansion(gco, GCOLabelID(alpha_label))

# swap
swap(gco::Cxx.CppPtr, maxIterationNum::Integer) = swap(gco, Cint(maxIterationNum))
alpha_beta_swap(gco::Cxx.CppPtr, alphaLabel::Integer, betaLabel::Integer) = alpha_beta_swap(gco, GCOLabelID(alphaLabel), GCOLabelID(betaLabel))
alpha_beta_swap(gco::Cxx.CppPtr, alphaLabel::Integer, betaLabel::Integer,
                alphaSites::Vector{Integer}, alphaSize::Integer, betaSites::Vector{Integer},
                betaSize::Integer) = alpha_beta_swap(gco, GCOLabelID(alphaLabel), GCOLabelID(betaLabel), Ref(convert(Vector{GCOSiteID}, alphaSites)),
                                                     GCOSiteID(alphaSize), Ref(convert(Vector{GCOSiteID}, betaSites), GCOSiteID(betaSize)))

# setDataCost
setDataCost(gco::Cxx.CppPtr, dataArray::Vector{Integer}) = setDataCost(gco, Ref(convert(Vector{GCOEnergyTermType}, dataArray)))
setDataCost(gco::Cxx.CppPtr, site::Integer, label::Integer, energy::Integer) = setDataCost(gco, GCOSiteID(site), GCOLabelID(label), GCOEnergyTermType(energy))
setDataCost(gco::Cxx.CppPtr, label::Integer, costs::GCOSparseDataCost, count::Integer) = setDataCost(gco, GCOLabelID(label), Ref(costs), GCOSiteID(count))

# setSmoothCost
setSmoothCost(gco::Cxx.CppPtr, label1::Integer, label2::Integer, energy::Integer) = setSmoothCost(gco, GCOLabelID(label1), GCOLabelID(label2), GCOEnergyTermType(energy))
setSmoothCost(gco::Cxx.CppPtr, smoothArray::Vector{Integer}) = setSmoothCost(gco, Ref(convert(Vector{GCOEnergyTermType}, smoothArray)))

# setLabelCost
setLabelCost(gco::Cxx.CppPtr, cost::Integer) = setLabelCost(gco, GCOEnergyTermType(cost))
setLabelCost(gco::Cxx.CppPtr, costArray::Vector{Integer}) = setLabelCost(gco, Ref(convert(Vector{GCOEnergyTermType}, costArray)))
setLabelSubsetCost(gco::Cxx.CppPtr, labels::Vector{Integer}, numLabels::Integer, cost::Integer) = setLabelSubsetCost(gco, Ref(convert(Vector{GCOLabelID, labels})), GCOLabelID(numLabels), GCOEnergyTermType(cost))

# whatLabel
whatLabel(gco::Cxx.CppPtr, site::Integer) = whatLabel(gco, GCOSiteID(site))
whatLabel(gco::Cxx.CppPtr, start::Integer, count::Integer, labeling::Vector{Integer}) = whatLabel(gco, GCOSiteID(start), GCOSiteID(count), Ref(convert(Vector{GCOLabelID}, labeling)))

# setLabel
setLabel(gco::Cxx.CppPtr, site::Integer, label::Integer) = setLabel(gco, GCOSiteID(site), GCOLabelID(label))

# setLabelOrder
setLabelOrder(gco::Cxx.CppPtr, isRandom::Bool) = setLabelOrder(gco, GCObool(isRandom))
setLabelOrder(gco::Cxx.CppPtr, order::Vector{Integer}, size::Integer) = setLabelOrder(gco, Ref(convert(Vector{GCOLabelID}, order)), GCOLabelID(size))

# setVerbosity
setVerbosity(gco::Cxx.CppPtr, level::Integer) = setVerbosity(Cint(level))
