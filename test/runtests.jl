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
