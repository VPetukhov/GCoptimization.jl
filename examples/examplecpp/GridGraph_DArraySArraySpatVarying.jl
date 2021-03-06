# "Uses spatially varying smoothness terms. That is
# V(p1,p2,l1,l2) = w_{p1,p2}*[min((l1-l2)*(l1-l2),4)], with
# w_{p1,p2} = p1+p2 if |p1-p2| == 1 and w_{p1,p2} = p1*p2 if |p1-p2| is not 1."
#
using GCoptimization

width = 10
height = 5
num_pixels = width * height
num_labels = 7
result = zeros(num_pixels)    # "stores result of optimization"

# "first set up the array for data costs"
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

# "next set up the array for smooth costs"
smooth = Vector{Int}(num_labels * num_labels)
for l1 = 0:num_labels-1, l2 = 0:num_labels-1
    smooth[l1+l2*num_labels+1] = (l1-l2)*(l1-l2) <= 4  ? (l1-l2)*(l1-l2) : 4;
end

# "next set up spatially varying arrays V and H"
V = Vector{Int}(num_pixels)
H = Vector{Int}(num_pixels)

for i = 0:num_pixels-1
    H[i+1] = i+(i+1)%3
    V[i+1] = i*(i+width)%7
end

gco = GCoptimizationGridGraph(width, height, num_labels)

setDataCost(gco, data)
setSmoothCostVH(gco, smooth, V, H)

println("Before optimization energy is ", compute_energy(gco))
expansion(gco, 2)    # "run expansion for 2 iterations."
println("After optimization energy is ", compute_energy(gco))

for i = 0:num_pixels-1
    result[i+1] = whatLabel(gco, i)
end

showall(result)
