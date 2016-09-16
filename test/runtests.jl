using GCoptimization
using Base.Test

# test gco types
@test isbits(GCOSparseDataCost) == true


# basic example
width = 10
height = 5
num_pixels = width * height
num_labels = 7

gco = GCoptimizationGridGraph(width, height, num_labels)

for i = 0:num_pixels-1, l = 0:num_labels-1
    if i < 25
        if l == 0
            setDataCost(gco, i, l, 0)
        else
            setDataCost(gco, i, l, 10)
        end
    else
        if l == 5
            setDataCost(gco, i, l, 0)
        else
            setDataCost(gco, i, l, 10)
        end
    end
end

for l1 = 0:num_labels-1, l2 = 0:num_labels-1
    cost = (l1-l2)^2 <= 4 ? (l1-l2)^2 : 4
    setSmoothCost(gco, l1, l2, cost)
end

@test compute_energy(gco) == 250
expansion(gco, 2)
@test compute_energy(gco) == 44


# DArraySArray
data = Vector{Int}(num_pixels * num_labels)
for i = 0:num_pixels-1, l = 0:num_labels-1
    if i < 25
        if l == 0
            data[i*num_labels+l+1] = 0
        else
            data[i*num_labels+l+1] = 10
        end
    else
        if l == 5
            data[i*num_labels+l+1] = 0
        else
            data[i*num_labels+l+1] = 10
        end
    end
end

smooth = Vector{Int}(num_labels * num_labels)
for l1 = 0:num_labels-1, l2 = 0:num_labels-1
    smooth[l1+l2*num_labels+1] = (l1-l2)*(l1-l2) <= 4  ? (l1-l2)*(l1-l2) : 4;
end

gco = GCoptimizationGridGraph(width, height, num_labels)
setDataCost(gco, data)
setSmoothCost(gco, smooth)

@test compute_energy(gco) == 250
expansion(gco, 2)
@test compute_energy(gco) == 44


# DfnSfn
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

@test compute_energy(gco) == 250
expansion(gco, 2)
@test compute_energy(gco) == 44
