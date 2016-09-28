using GCoptimization

width = 10
height = 5
pixelNum = width * height
labelNum = 7
result = zeros(pixelNum)

gco = GCoptimizationGridGraph(width, height, labelNum)

function dataFn(pixel::GCOSiteID, label::GCOLabelID)::GCOEnergyTermType
    if pixel < 25
        return label == 0 ? 0 : 10
    else
        return label == 5 ? 0 : 10
    end
end
setDataCost(gco, dataFn)

smoothFn(p1::GCOSiteID, p2::GCOSiteID, l1::GCOLabelID, l2::GCOLabelID)::GCOEnergyTermType = (l1-l2)*(l1-l2) <= 4 ? (l1-l2)*(l1-l2) : 4
setSmoothCost(gco, smoothFn)

println("Before optimization energy is ", compute_energy(gco))
expansion(gco, 2)
println("After optimization energy is ", compute_energy(gco))


result = [whatLabel(gco, i-1) for i = 1:pixelNum]


showall(result)
