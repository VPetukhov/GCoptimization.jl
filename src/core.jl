# core functionalities

# grid graph
GCoptimizationGridGraph{T<:Integer}(width::T, height::T, numLabels::Integer) = GCoptimizationGridGraph(GCOSiteID(width), GCOSiteID(height), GCOLabelID(numLabels))
setSmoothCostVH{T<:Integer}(gco::Cxx.CppPtr, smoothArray::Vector{T}, vCosts::Vector{T},
                hCosts::Vector{T}) = setSmoothCostVH(gco, pointer(convert(Vector{GCOEnergyTermType}, smoothArray)),
                                                          pointer(convert(Vector{GCOEnergyTermType}, vCosts)),
                                                          pointer(convert(Vector{GCOEnergyTermType}, hCosts)))

# general graph
GCoptimizationGeneralGraph(numSites::Integer, numLabels::Integer) = GCoptimizationGeneralGraph(GCOSiteID(numSites), GCOLabelID(numLabels))
setNeighbors{T<:Integer}(gco::Cxx.CppPtr, site1::T, site2::T) = setNeighbors(gco, GCOSiteID(site1), GCOSiteID(site2))
setNeighbors{T<:Integer}(gco::Cxx.CppPtr, site1::T, site2::T, weight::Integer) = setNeighbors(gco, GCOSiteID(site1), GCOSiteID(site2), GCOEnergyTermType(weight))

# expansion
expansion(gco::Cxx.CppPtr, maxIterationNum::Integer) = expansion(gco, Cint(maxIterationNum))
alpha_expansion(gco::Cxx.CppPtr, alphaLabel::Integer) = alpha_expansion(gco, GCOLabelID(alphaLabel))

# swap
swap(gco::Cxx.CppPtr, maxIterationNum::Integer) = swap(gco, Cint(maxIterationNum))
alpha_beta_swap{T<:Integer}(gco::Cxx.CppPtr, alphaLabel::T, betaLabel::T) = alpha_beta_swap(gco, GCOLabelID(alphaLabel), GCOLabelID(betaLabel))
alpha_beta_swap{T<:Integer, N<:Integer}(gco::Cxx.CppPtr, alphaLabel::T, betaLabel::T,
                alphaSites::Vector{N}, alphaSize::N, betaSites::Vector{N},
                betaSize::N) = alpha_beta_swap(gco, GCOLabelID(alphaLabel), GCOLabelID(betaLabel), pointer(convert(Vector{GCOSiteID}, alphaSites)),
                                                     GCOSiteID(alphaSize), Ref(convert(Vector{GCOSiteID}, betaSites), GCOSiteID(betaSize)))

# setDataCost
setDataCost{T<:Integer}(gco::Cxx.CppPtr, dataArray::Vector{T}) = setDataCost(gco, pointer(convert(Vector{GCOEnergyTermType}, dataArray)))
setDataCost(gco::Cxx.CppPtr, site::Integer, label::Integer, energy::Integer) = setDataCost(gco, GCOSiteID(site), GCOLabelID(label), GCOEnergyTermType(energy))
setDataCost(gco::Cxx.CppPtr, label::Integer, costs::GCOSparseDataCost, count::Integer) = setDataCost(gco, GCOLabelID(label), pointer(costs), GCOSiteID(count))

# setSmoothCost
setSmoothCost{T<:Integer}(gco::Cxx.CppPtr, label1::T, label2::T, energy::Integer) = setSmoothCost(gco, GCOLabelID(label1), GCOLabelID(label2), GCOEnergyTermType(energy))
setSmoothCost{T<:Integer}(gco::Cxx.CppPtr, smoothArray::Vector{T}) = setSmoothCost(gco, pointer(convert(Vector{GCOEnergyTermType}, smoothArray)))

# setLabelCost
setLabelCost(gco::Cxx.CppPtr, cost::Integer) = setLabelCost(gco, GCOEnergyTermType(cost))
setLabelCost{T<:Integer}(gco::Cxx.CppPtr, costArray::Vector{T}) = setLabelCost(gco, pointer(convert(Vector{GCOEnergyTermType}, costArray)))
setLabelSubsetCost{T<:Integer}(gco::Cxx.CppPtr, labels::Vector{T}, numLabels::Integer, cost::Integer) = setLabelSubsetCost(gco, pointer(convert(Vector{GCOLabelID, labels})), GCOLabelID(numLabels), GCOEnergyTermType(cost))

# whatLabel
whatLabel(gco::Cxx.CppPtr, site::Integer) = whatLabel(gco, GCOSiteID(site))
whatLabel{T<:Integer, N<:Integer}(gco::Cxx.CppPtr, start::T, count::T, labeling::Vector{N}) = whatLabel(gco, GCOSiteID(start), GCOSiteID(count), pointer(convert(Vector{GCOLabelID}, labeling)))

# setLabel
setLabel(gco::Cxx.CppPtr, site::Integer, label::Integer) = setLabel(gco, GCOSiteID(site), GCOLabelID(label))

# setLabelOrder
setLabelOrder(gco::Cxx.CppPtr, isRandom::Bool) = setLabelOrder(gco, GCObool(isRandom))
setLabelOrder{T<:Integer}(gco::Cxx.CppPtr, order::Vector{T}, size::Integer) = setLabelOrder(gco, Ref(convert(Vector{GCOLabelID}, order)), GCOLabelID(size))

# setVerbosity
setVerbosity(gco::Cxx.CppPtr, level::Integer) = setVerbosity(gco, Cint(level))
