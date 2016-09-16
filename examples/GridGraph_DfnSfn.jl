using GCoptimization

width = 10
height = 5
num_pixels = width * height
num_labels = 7
result = zeros(num_pixels)

gco = GCoptimizationGridGraph(width, height, num_labels)

function dataFn(p::GCOSiteID, l::GCOLabelID)::GCOEnergyTermType
    if p < 25
        return l == 0 ? 0 : 10
    else
        return l == 5 ? 0 : 10
    end
end
setDataCost(gco, dataFn)

smoothFn(p1::GCOSiteID, p2::GCOSiteID, l1::GCOLabelID, l2::GCOLabelID)::GCOEnergyTermType = (l1-l2)*(l1-l2) <= 4 ? (l1-l2)*(l1-l2) : 4
setSmoothCost(gco, smoothFn)

println("Before optimization energy is ", compute_energy(gco))
expansion(gco, 2)
println("After optimization energy is ", compute_energy(gco))

for i = 0:num_pixels-1
    result[i+1] = whatLabel(gco, i)
end

showall(result)
