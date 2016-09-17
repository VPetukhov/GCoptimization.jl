# "in this version, set data and smoothness terms using arrays.
#  grid neighborhood structure is assumed.#
#
using GCoptimization

width = 10
height = 5
num_pixels = width * height
num_labels = 7
result = zeros(num_pixels)    # "stores result of optimization"

immutable ForDataFn
    data::Vector{Cint}
    numLab::Cint
end

function dataFn(p::GCOSiteID, l::GCOLabelID, data::Ptr{Void})::GCOEnergyTermType
    myData = unsafe_pointer_to_objref(data)
    numLab = myData.numLab
    return myData.data[p*numLab+l+1]
end

smoothFn(p1::GCOSiteID, p2::GCOSiteID, l1::GCOLabelID, l2::GCOLabelID)::GCOEnergyTermType = (l1-l2)*(l1-l2) <= 4 ? (l1-l2)*(l1-l2) : 4

# "first set up the array for data costs"
data = Vector{Cint}(num_pixels * num_labels)
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

gco = GCoptimizationGridGraph(width, height, num_labels)

# "set up the needed data to pass to function for the data costs"
toFn = ForDataFn(data, num_labels)
setDataCost(gco, dataFn, pointer_from_objref(toFn))

# "smoothness comes from function pointer"
setSmoothCost(gco, smoothFn)

println("Before optimization energy is ", compute_energy(gco))
expansion(gco, 2)    # "run expansion for 2 iterations."
println("After optimization energy is ", compute_energy(gco))

for i = 0:num_pixels-1
    result[i+1] = whatLabel(gco, i)
end

showall(result)
