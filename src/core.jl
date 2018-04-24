# core functionalities
# the suffix ♂(\mars) means this value is 0-based index.

# grid graph
GCoptimizationGridGraph(width::T, height::T, numLabels::Integer) where {T <: Integer} = GCoptimizationGridGraph(GCOSiteID(width), GCOSiteID(height), GCOLabelID(numLabels))
setSmoothCostVH(gco::Cxx.CppPtr, smoothArray::Vector{T}, vCosts::Vector{T},
                hCosts::Vector{T}) where {T <: Integer} = setSmoothCostVH(gco, pointer(convert(Vector{GCOEnergyTermType}, smoothArray)),
                                                          pointer(convert(Vector{GCOEnergyTermType}, vCosts)),
                                                          pointer(convert(Vector{GCOEnergyTermType}, hCosts)))

# general graph
GCoptimizationGeneralGraph(numSites::Integer, numLabels::Integer) = GCoptimizationGeneralGraph(GCOSiteID(numSites), GCOLabelID(numLabels))
setNeighbors(gco::Cxx.CppPtr, site1♂::T, site2♂::T) where {T <: Integer} = setNeighbors(gco, GCOSiteID(site1♂), GCOSiteID(site2♂))
setNeighbors(gco::Cxx.CppPtr, site1♂::T, site2♂::T, weight::Integer) where {T <: Integer} = setNeighbors(gco, GCOSiteID(site1♂), GCOSiteID(site2♂), GCOEnergyTermType(weight))

# expansion
expansion(gco::Cxx.CppPtr, maxIterationNum::Integer) = expansion(gco, Cint(maxIterationNum))
alpha_expansion(gco::Cxx.CppPtr, alphaLabel♂::Integer) = alpha_expansion(gco, GCOLabelID(alphaLabel♂))

# swap
swap(gco::Cxx.CppPtr, maxIterationNum::Integer) = swap(gco, Cint(maxIterationNum))
alpha_beta_swap(gco::Cxx.CppPtr, alphaLabel♂::T, betaLabel♂::T) where {T <: Integer} = alpha_beta_swap(gco, GCOLabelID(alphaLabel♂), GCOLabelID(betaLabel♂))
alpha_beta_swap(gco::Cxx.CppPtr, alphaLabel♂::T, betaLabel♂::T,
                alphaSites♂::Vector{N}, alphaSize::N, betaSites♂::Vector{N},
                betaSize::N) where {T <: Integer,N <: Integer} = alpha_beta_swap(gco, GCOLabelID(alphaLabel♂), GCOLabelID(betaLabel♂), pointer(convert(Vector{GCOSiteID}, alphaSites♂)),
                                                     GCOSiteID(alphaSize), pointer(convert(Vector{GCOSiteID}, betaSites♂), GCOSiteID(betaSize)))

# setDataCost
setDataCost(gco::Cxx.CppPtr, dataArray::Vector{T}) where {T <: Integer} = setDataCost(gco, pointer(convert(Vector{GCOEnergyTermType}, dataArray)))
setDataCost(gco::Cxx.CppPtr, site♂::Integer, label♂::Integer, energy::Integer) = setDataCost(gco, GCOSiteID(site♂), GCOLabelID(label♂), GCOEnergyTermType(energy))
setDataCost(gco::Cxx.CppPtr, label♂::Integer, costs::GCOSparseDataCost, count::Integer) = setDataCost(gco, GCOLabelID(label♂), pointer(costs), GCOSiteID(count))

# setSmoothCost
setSmoothCost(gco::Cxx.CppPtr, label1♂::T, label2♂::T, energy::Integer) where {T <: Integer} = setSmoothCost(gco, GCOLabelID(label1♂), GCOLabelID(label2♂), GCOEnergyTermType(energy))
setSmoothCost(gco::Cxx.CppPtr, smoothArray::Vector{T}) where {T <: Integer} = setSmoothCost(gco, pointer(convert(Vector{GCOEnergyTermType}, smoothArray)))

# setLabelCost
setLabelCost(gco::Cxx.CppPtr, cost::Integer) = setLabelCost(gco, GCOEnergyTermType(cost))
setLabelCost(gco::Cxx.CppPtr, costArray::Vector{T}) where {T <: Integer} = setLabelCost(gco, pointer(convert(Vector{GCOEnergyTermType}, costArray)))
setLabelSubsetCost(gco::Cxx.CppPtr, labels♂::Vector{T}, numLabels::Integer, cost::Integer) where {T <: Integer} = setLabelSubsetCost(gco, pointer(convert(Vector{GCOLabelID}, labels♂)), GCOLabelID(numLabels), GCOEnergyTermType(cost))

# whatLabel
whatLabel(gco::Cxx.CppPtr, site♂::Integer) = whatLabel(gco, GCOSiteID(site♂))
whatLabel(gco::Cxx.CppPtr, start♂::T, count::T, labeling::Vector{N}) where {T <: Integer,N <: Integer} = whatLabel(gco, GCOSiteID(start♂), GCOSiteID(count), pointer(convert(Vector{GCOLabelID}, labeling)))

# setLabel
setLabel(gco::Cxx.CppPtr, site♂::Integer, label♂::Integer) = setLabel(gco, GCOSiteID(site♂), GCOLabelID(label♂))

# setLabelOrder
setLabelOrder(gco::Cxx.CppPtr, isRandom::Bool) = setLabelOrder(gco, GCObool(isRandom))
setLabelOrder(gco::Cxx.CppPtr, order::Vector{T}, size::Integer) where {T <: Integer} = setLabelOrder(gco, pointer(convert(Vector{GCOLabelID}, order)), GCOLabelID(size))

# setVerbosity
setVerbosity(gco::Cxx.CppPtr, level::Integer) = setVerbosity(gco, Cint(level))
