using GCoptimization

width = 10
height = 5
num_pixels = width * height
num_labels = 7
result = zeros(num_pixels)

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

gco = GCoptimizationGeneralGraph(num_pixels, num_labels)
setDataCost(gco, data)
setSmoothCost(gco, smooth)

for y = 0:height-1, x = 1:width-1
    setNeighbors(gco, x+y*width, x-1+y*width)
end

for y = 1:height-1, x = 0:width-1
    setNeighbors(gco, x+y*width, x+(y-1)*width)
end

println("Before optimization energy is ", compute_energy(gco))
expansion(gco, 2)
println("After optimization energy is ", compute_energy(gco))

for i = 0:num_pixels-1
    result[i+1] = whatLabel(gco, i)
end

showall(result)
