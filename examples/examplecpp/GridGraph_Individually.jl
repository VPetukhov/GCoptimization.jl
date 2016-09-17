# "smoothness and data costs are set up one by one, individually.
#  grid neighborhood structure is assumed."
#
using GCoptimization

width = 10
height = 5
num_pixels = width * height
num_labels = 7
result = zeros(num_pixels)    # "stores result of optimization"

gco = GCoptimizationGridGraph(width, height, num_labels)

# "first set up data costs individually"
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

# "next set up smoothness costs individually"
for l1 = 0:num_labels-1, l2 = 0:num_labels-1
    cost = (l1-l2)^2 <= 4 ? (l1-l2)^2 : 4
    setSmoothCost(gco, l1, l2, cost)
end

println("Before optimization energy is ", compute_energy(gco))
expansion(gco, 2)    # "run expansion for 2 iterations."
println("After optimization energy is ", compute_energy(gco))

for i = 0:num_pixels-1
    result[i+1] = whatLabel(gco, i)
end

showall(result)
